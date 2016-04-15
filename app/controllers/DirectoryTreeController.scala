package controllers

import java.io.{FileFilter, File}
import java.nio.file.{Paths, Path, Files}
import javax.inject._

import play.api.libs.json._
import play.api.mvc._

import scala.concurrent.ExecutionContext

@Singleton
class DirectoryTreeController @Inject()()(implicit exec: ExecutionContext) extends Controller {
  implicit val fileAsNode = new Writes[File] {
    def writes(file: File) = {
      Json.obj (
        "path" -> file.getAbsolutePath,
        "name" -> file.getName,
        "isDirectory" -> file.isDirectory
      )
    }
  }

  private val fileFilter = new FileFilter {
    def accept(pathname: File): Boolean = {
      (!pathname.isHidden) && pathname.canRead
    }
  }

  def getDirectory(directoryOpt: Option[String]) = Action {
    val directory = {
      val directoryOrHash = directoryOpt.getOrElse("#")
      if (directoryOrHash == "#")
        "/"
      else
        directoryOrHash
    }
    val path = Paths.get(directory)
    if (!Files.isDirectory(path)) {
      NotFound(s"$directory is not a valid directory")
    } else {
      Ok(
        Json.obj (
          "path" -> path.toFile.getAbsolutePath,
          "items" -> Json.toJson(path.toFile.listFiles(fileFilter))
        )
      )
    }
  }
}
