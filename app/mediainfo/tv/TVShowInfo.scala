package mediainfo.tv

import scala.concurrent.Future

trait TVShowSearchResult {
  def title: String
  def id: String
  def description: String
}

sealed trait TVShowStatus
object TVShowStatus {
  case object Continuing extends TVShowStatus
  case object Ended extends TVShowStatus
  case object Unknown extends TVShowStatus
}

case class TVShow(
  id: String,
  title: String,
  description: String,
  status: TVShowStatus
)

case class TVShowEpisode(
  id: String,
  title: String,
  summary: String,
  seasonNumber: Int,
  episodeNumber: Int
)

trait TVShowInfo {
  def showSearch(query: String): Future[Seq[TVShowSearchResult]]
  def showInfo(id: String): Future[Option[TVShow]]
  def showEpisodes(id: String): Future[Seq[TVShowEpisode]]
}
