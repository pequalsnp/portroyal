package mediainfo.tv

import scala.concurrent.Future

trait TVShowDAO {
  def getShow(id: String): Future[Option[TVShow]]
  def putShow(id: String, show: TVShow): Future[Unit]
  def getShowEpisodes(id: String): Future[Seq[TVShowEpisode]]
}
