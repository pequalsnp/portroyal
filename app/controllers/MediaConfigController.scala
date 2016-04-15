package controllers

import javax.inject._
import mediainfo.tv.{TVShowEpisode, TVShow, TVShowSearchResult, TVShowInfo}
import play.api._
import play.api.libs.json._
import play.api.mvc._
import scala.concurrent.{ExecutionContext, Future, Promise}

@Singleton
class MediaConfigController @Inject()(tvShowInfo: TVShowInfo)(implicit exec: ExecutionContext) extends Controller {

  implicit val tvShowWrites = new Writes[TVShow] {
    def writes(tvShow: TVShow) = Json.obj (
      "title" -> tvShow.title,
      "description" -> tvShow.description,
      "id" -> tvShow.id
    )
  }

  implicit val tvShowSearchResultWriter = new Writes[TVShowSearchResult] {
    def writes(searchResult: TVShowSearchResult) = Json.obj (
      "title" -> searchResult.title,
      "description" -> searchResult.description,
      "id" -> searchResult.id
    )
  }

  def tvShowSearch(query: String) = Action.async {
    tvShowInfo.showSearch(query).map { searchResults: Seq[TVShowSearchResult] =>
      Ok(Json.obj (
        "results" -> Json.toJson(searchResults)
      ))
    }
  }
}
