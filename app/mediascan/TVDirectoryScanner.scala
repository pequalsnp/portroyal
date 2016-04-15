package mediascan

import java.nio.file.attribute.BasicFileAttributes
import java.nio.file._

import com.google.inject.{Singleton, Inject}
import mediainfo.tv.{TVShowSearchResult, TVShowInfo}
import scala.collection.JavaConverters._
import scala.collection.mutable
import scala.concurrent.{ExecutionContext, Future, Await}
import scala.concurrent.duration.Duration

sealed trait TVShowMatch

case class SingleTVShowMatch(searchResult: TVShowSearchResult) extends TVShowMatch
case class MultiplePossibleTVShowMatch(searchResults: Seq[TVShowSearchResult]) extends TVShowMatch

class TVDirectoryFileVisiter(scanDir: Path, tvShowInfo: TVShowInfo)(implicit exec: ExecutionContext) extends SimpleFileVisitor[Path] {
  val showMatches = mutable.Set.empty[TVShowMatch]

  override def preVisitDirectory(directory: Path, attributes: BasicFileAttributes): FileVisitResult = {
    if (directory == scanDir)
      return FileVisitResult.CONTINUE
    val name = directory.getFileName
    val showSearchResultF: Future[Option[TVShowMatch]] = tvShowInfo.showSearch(name.toString).map { results: Seq[TVShowSearchResult] =>
      if (results.size == 1)
        Some(SingleTVShowMatch(searchResult = results.head))
      else if (results.size > 1)
        Some(MultiplePossibleTVShowMatch(searchResults = results))
      else
        None
    }
    Await.result(showSearchResultF, atMost = Duration.Inf) match {
      case Some(result) => showMatches += result; FileVisitResult.SKIP_SUBTREE
      case _ => FileVisitResult.CONTINUE
    }
  }
}

@Singleton
class TVDirectoryScanner @Inject()(tvShowInfo: TVShowInfo)(implicit exec: ExecutionContext) {
  def scanDir(directory: String): Set[TVShowMatch] = {
    val scanDirPath = FileSystems.getDefault.getPath(directory)
    val visiter = new TVDirectoryFileVisiter(scanDirPath, tvShowInfo)
    Files.walkFileTree(
      scanDirPath,
      Set(FileVisitOption.FOLLOW_LINKS).asJava,
      Integer.MAX_VALUE,
      visiter
    )

    Set.empty ++ visiter.showMatches
  }
}
