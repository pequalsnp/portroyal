package providers

import com.google.inject.{Provider, Inject}
import mediainfo.tv.{TVShowDAO, TVShowInfo}
import mediainfo.tv.tvdb.TVDBTVShowInfo
import play.api.Configuration
import play.api.libs.ws.WSClient

import scala.concurrent.ExecutionContext

class TVDBTVShowInfoProvider @Inject()(
  configuration: Configuration,
  ws: WSClient,
  tvShowDAO: TVShowDAO
)(implicit exec: ExecutionContext) extends Provider[TVShowInfo] {
  override def get(): TVShowInfo = {
    val tvdbApiKey = configuration.getString("tvdb.apiKey")
      .getOrElse(throw new RuntimeException("TVDB API Key required with config key tvdb.apiKey"))
    new TVDBTVShowInfo(apiKey = tvdbApiKey, ws = ws, tvShowDAO = tvShowDAO)
  }
}
