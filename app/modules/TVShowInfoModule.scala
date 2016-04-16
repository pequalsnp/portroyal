package modules

import com.google.inject.AbstractModule
import mediainfo.tv.{InMemoryTVShowDAO, TVShowDAO, TVShowInfo}
import net.codingwell.scalaguice.ScalaModule
import providers.TVDBTVShowInfoProvider

class TVShowInfoModule extends AbstractModule with ScalaModule {
  override def configure() = {
    bind[TVShowInfo].toProvider[TVDBTVShowInfoProvider]
    bind[TVShowDAO].toInstance(new InMemoryTVShowDAO)
  }
}
