RelatedHashtag <- function(token = NULL, hashtag = NULL) {
  if (is.null(token) || is.null(hashtag)) {
    stop('Neither token nor hashtag can be NULL')
  }

  base_url <- "https://api.twitter.com/1.1/search/tweets.json"
  url <- paste0(base_url, "?count=100&q=%23", hashtag, "&cursor=-1")

  ldf <- APIcall(token, url)
  all_tweets <- list()

  if (! is.null(ldf$statuses$text)) {
    all_tweets <- append(all_tweets, ldf$statuses$text)
  }

  while(! is.null(ldf$search_metadata$next_results)) {
    url <- paste0(base_url, ldf$search_metadata$next_results)
    ldf <- APIcall(token, url)
    if (! is.null(ldf$statuses$text)) {
      all_tweets <- append(all_tweets, ldf$statuses$text)
    }
  }

  lapply(all_tweets, function(x) {
                      regmatches(x , gregexpr("#[^ ]*", x))[[1]]})
}