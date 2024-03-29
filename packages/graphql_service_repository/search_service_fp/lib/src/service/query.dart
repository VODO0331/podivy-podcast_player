


const String queryForExploreContent = """
query  search(
    \$podcastFirst: Int,
    \$categories: [String],
    \$language: String,
    \$podcastsSortBy: PodcastSortType!
  ){
    podcasts(
      first:\$podcastFirst, 
      filters:{
        language:\$language,
        categories:\$categories, 
      },
      sort:{sortBy: \$podcastsSortBy}
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
    \$airDateForm: DateTime
    \$airDateTo: DateTime
    \$language: String,
  ){
    podcasts(
      first: \$podcastFirst, 
      filters:{
         language:\$language,
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
      filters:{categories:{terms:\$categories},airDate:{from: \$airDateForm, to: \$airDateTo}}
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
    \$airDateForm: DateTime
    \$airDateTo: DateTime
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
      filters:{airDate:{from: \$airDateForm, to: \$airDateTo}},
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

const String queryPodcastData = """
  query GetPodcast(
    \$podcastId : String!,
    \$identifierType : PodcastIdentifierType!,
    \$episodesFirst : Int,
    \$episodesortBy : EpisodeSortType!,
    \$episodedirection : SortDirection,
){
    podcast(identifier : {id : \$podcastId , type: \$identifierType}){
      id
      title
      imageUrl
      language
      description
      categories{
        title
      }
      numberOfEpisodes
      socialLinks{
        twitter
        facebook
        instagram
      } 
      episodes(first : \$episodesFirst, 
      sort:{sortBy: \$episodesortBy, direction: \$episodedirection}){
        data {
          id
          title
          audioUrl
          description
          airDate
          
        }
      }
    }
  }
     
  
""";