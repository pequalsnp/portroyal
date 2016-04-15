package modules

import com.google.inject.AbstractModule
import mediainfo.tv.{InMemoryTVShowDAO, TVShowDAO, TVShowInfo}
import providers.TVDBTVShowInfoProvider

class TVShowInfoModule extends AbstractModule {
  override def configure() = {
    bind(classOf[TVShowInfo]).toProvider(classOf[TVDBTVShowInfoProvider])
    bind(classOf[TVShowDAO]).toInstance(new InMemoryTVShowDAO)
  }
}
