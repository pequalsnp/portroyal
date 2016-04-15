package mediainfo.tv

import scala.collection.mutable
import scala.concurrent.Future

class InMemoryTVShowDAO extends TVShowDAO {
  private val tvShows: mutable.Map[String, TVShow] = mutable.Map.empty

  override def getShow(id: String): Future[Option[TVShow]] = {
    Future.successful(tvShows.get(id))
  }

  override def putShow(id: String, show: TVShow): Future[Unit] = {
    tvShows += (id -> show)
    Future.successful(())
  }

  override def getShowEpisodes(id: String): Future[Seq[TVShowEpisode]] = {
    Future.successful(Seq.empty)
  }
}
