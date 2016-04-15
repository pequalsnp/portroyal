package mediainfo.tv.tvdb

import java.io.{ByteArrayInputStream, BufferedWriter}
import java.util.zip.{ZipInputStream, ZipFile}

import mediainfo.tv._
import play.api.libs.ws.{WSResponse, WSClient}
import scala.collection.mutable
import scala.concurrent.{ExecutionContext, Future}
import scala.xml._

object TVDBTVShowInfo {
  private val ShowSearchURL = "https://thetvdb.com/api/GetSeries.php"
  private val SeriesNameParam = "seriesname"

  private def readCurrentZipEntryToBytes(zipInputStream: ZipInputStream): Seq[Byte] = {
    val buffer = new Array[Byte](1024)
    val builder = Seq.newBuilder[Byte]
    var len = 0
    do {
      len = zipInputStream.read(buffer)
      if (len > 0) {
        builder ++= buffer.slice(0, len)
      }
    } while (len > 0)
    builder.result()
  }

  private val SeriesTag = "Series"
  private val SeriesNameTag = "SeriesName"
  private val OverviewTag = "Overview"
  private val IDTag = "id"
  private val StatusTag = "Status"
  private val EpisodeTag = "Episode"
  private val EpisodeNameTag = "EpisodeName"
  private val EpisodeOverviewTag = "Overview"
  private val EpisodeNumberTag = "EpisodeNumber"
  private val EpisodeSeasonNumberTag = "SeasonNumber"

  private def getShowStatus(statusNode: Node): TVShowStatus = {
    statusNode.text match {
      case "Continuing" => TVShowStatus.Continuing
      case "Ended" => TVShowStatus.Ended
      case _ => TVShowStatus.Unknown
    }
  }

  private def processBaseSeriesRecord(seriesNode: Node): TVShow = {
    TVShow(
      id = (seriesNode \ IDTag).text,
      title = (seriesNode \ SeriesNameTag).text,
      description = (seriesNode \ OverviewTag).text,
      status = getShowStatus((seriesNode \ StatusTag).head)
    )
  }

  private def processEpisodeRecord(episodeNode: Node): TVShowEpisode = {
    TVShowEpisode(
      id = (episodeNode \ IDTag).text,
      title = (episodeNode \ EpisodeNameTag).text,
      summary = (episodeNode \ EpisodeOverviewTag).text,
      episodeNumber = (episodeNode \ EpisodeNumberTag).text.toInt,
      seasonNumber = (episodeNode \ EpisodeSeasonNumberTag).text.toInt
    )
  }

  private def processFullSeriesRecord(xmlAsBytes: Array[Byte]): (TVShow, Seq[TVShowEpisode]) = {
    val rootNode = XML.load(new ByteArrayInputStream(xmlAsBytes))
    val tvShow = processBaseSeriesRecord((rootNode \ SeriesTag).head)
    val episodeNodess = rootNode \ EpisodeTag
    val episodes = episodeNodess.theSeq.map(processEpisodeRecord)
    (tvShow, episodes)
  }
}

class TVDBTVShowInfo(
  apiKey: String,
  ws: WSClient,
  tvShowDAO: TVShowDAO
)(implicit exec: ExecutionContext) extends TVShowInfo {
  import TVDBTVShowInfo._

  override def showSearch(query: String): Future[Seq[TVShowSearchResult]] = {
    ws.url(ShowSearchURL).withQueryString((SeriesNameParam, query)).get().map { response: WSResponse =>
      val rootNode = XML.loadString(response.body)
      val series: NodeSeq = rootNode \ SeriesTag
      series.theSeq.collect {
        case seriesNode: Node if (seriesNode \ "language").text == "en" =>
          val seriesName = seriesNode \ SeriesNameTag
          val seriesDescription = seriesNode \ OverviewTag
          val seriesId = seriesNode \ IDTag
          new TVShowSearchResult {
            override def title: String = seriesName.text
            override def description: String = seriesDescription.text
            override def id: String = seriesId.text
          }
      }
    }
  }

  private def updateShow(id: String): Future[Unit] = {
    val url = s"https://thetvdb.com/api/$apiKey/series/$id/all/en.zip"
    ws.url(url).get().flatMap {response: WSResponse =>
      val inputStream = new ByteArrayInputStream(response.bodyAsBytes.toArray)
      val zipInputStream = new ZipInputStream(inputStream)
      var zipEntry = zipInputStream.getNextEntry
      var updateF = Future.successful(())
      while (zipEntry != null) {
        zipEntry.getName() match {
          case "en.xml" =>
            val (show, episodes) = processFullSeriesRecord(readCurrentZipEntryToBytes(zipInputStream).toArray)
            updateF = tvShowDAO.putShow(id, show)
          case _ =>
        }
        zipInputStream.closeEntry()
        zipEntry = zipInputStream.getNextEntry
      }
      zipInputStream.close()
      updateF
    }
  }

  override def showInfo(id: String): Future[Option[TVShow]] = {
    tvShowDAO.getShow(id).flatMap {
      case Some(show) => Future.successful(Some(show))
      case None => updateShow(id).flatMap(_ => tvShowDAO.getShow(id))
    }

  }

  override def showEpisodes(id: String): Future[Seq[TVShowEpisode]] = {
    Future.successful(Seq.empty)
  }
}
