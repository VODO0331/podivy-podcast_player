
 const String queryLatestList = """
  query GetPodcastsForLatestList(
    \$languageFilter: String,
    \$first: Int, 
    \$podcastsSortBy: PodcastSortType!,
    \$episodeDirection: SortDirection,
    \$episodesortBy: EpisodeSortType!
  ){
    podcasts(
      filters: {language: \$languageFilter,},
      first: \$first, 
      sort: {sortBy: \$podcastsSortBy},
    ){
      data{
        id
        title
        imageUrl
        episodes(
          sort:{
            sortBy: \$episodesortBy, 
            direction:\$episodeDirection,
            first: \$first,}
        ){
            data{
              id
              title
              audioUrl
              htmlDescription
            }
        }
      }
    }
  }
""";

const String queryForExploreContent = """
query  search(
    \$podcastFirst: Int,
    \$categories: [String],
  ){
    podcasts(
      first:\$podcastFirst, 
      filters:{
        categories:\$categories, 
      },
      ){
      data{
        id
        title
        imageUrl
      }
     }
    }
""";

const String queryForCategories = """
query  search(
    \$podcastFirst: Int,
    \$episodesFirst: Int,
    \$categories : [String],
    \$episodesSortBy: EpisodeSortType!
  ){
    podcasts(
      first: \$podcastFirst, 
      filters:{
        categories:\$categories, 
      },
      ){
      data{
        id
        title
        imageUrl
      }
    }
    episodes(
      first: \$episodesFirst, 
      filters:{categories:{terms:\$categories},}
      sort:{sortBy: \$episodesSortBy}){
        data{
          id
          title
          audioUrl
          description 
          airDate
            podcast{
              id
              title
              imageUrl
              }
        }
    }

}

""";

const String queryForKeyword = """
query  search(
    \$podcastFirst: Int,
    \$episodesFirst: Int,
    \$searchTerm: String,
    \$episodesSortBy: EpisodeSortType!
  ){
    podcasts(
      first: \$podcastFirst, 
      searchTerm: \$searchTerm,
      ){
      data{
        id
        title
        imageUrl
      }
    }
    episodes(
      first: \$episodesFirst, 
      searchTerm: \$searchTerm,
      sort:{sortBy: \$episodesSortBy}){
        data{
          id
          title
          audioUrl
          description 
          airDate
            podcast{
              id
              title
              imageUrl
              }
        }
    }

}

""";

