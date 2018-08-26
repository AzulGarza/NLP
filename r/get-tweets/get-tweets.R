
# Objetivo ----------------------------------------------------------------

# Obtener tweets con un solo emoticón

# Paquetes ----------------------------------------------------------------

pacman::p_load(tidyverse, rtweet, tidytext, install = F) 
                                        # Si no se tienen los paquetes
                                        # Cambiar a install = F



# Api twitter -------------------------------------------------------------

# Nombre
appname <- "tweets-emojis"

# Key
key <- 

# Secret
secret <- 

# Token
twitter_token <- 
  create_token(
    app = appname,
    consumer_key = key,
    consumer_secret = secret
  )


# Datos de emojis ---------------------------------------------------------

emojis_m <- 
  rtweet::emojis %>% 
  mutate(
    clave = case_when(
      description == "grinning face" ~ 0,  
      description == "disappointed face" ~ 1,
      description == "angry face" ~ 2,
      description == "face savoring food" ~ 3,
      description == "read heart" ~ 4,
      description == "thumbs up" ~ 5,
      description == "thumbs down" ~ 6,
      description == "clapping hands" ~ 7,
      description == "telephone" ~ 8,
      description == "money bag" ~ 9,
      description == "cigarette" ~ 10,
      description == "soccer ball" ~ 11,
      description == "bikini" ~ 12,
      description == "raising hands" ~ 13,
      description == "cross mark" ~ 14,
      description == "OK hand" ~ 15,
      TRUE ~ 16
    )
  ) %>% 
  filter(!clave == 16) 

# Función para convertir emojis
convert_emoji <- function(emoji){
  iconv(emoji, from = "latin1", to = "ASCII", sub = "byte")
}

# Función para reconvetir emojis
reconvert_emoji <- function(emoji){
  iconv(emoji, from = "UTF-8", to = "latin1", sub = "byte")
}

# Emojis para filtrar,
# los que se acordaron en github
emojis_find <- 
  emojis_m %>% 
  pull(code) %>% 
  str_c(collapse = "|")

# Emojis totales
emojis_tot <- 
  rtweet::emojis %>% 
  pull(code) %>% 
  #convert_emoji %>% 
  str_c(collapse = "|") 



# funcion de tweets -------------------------------------------------------

get_clean_tweets <- function(emoji_code){
  # Con esta funciòn obtenemos la base con el texto
  # y el emoji 
  # Obtención de tweets -----------------------------------------------------
  
  raw_tweets <- 
    search_tweets(
      emoji_code, n = 500, lang = "es",  include_rts = F#, 
      #retryonratelimit = T
    )
  
  
  # Mmodificamos los tweets -------------------------------------------------
  
  tidy_tweets <- 
    raw_tweets %>% 
    select(text) %>% 
    mutate(
      clean_text = str_replace_all(
        text, 
        "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https|@\\w+|#\\w+", 
        ""
      ),
      clean_text = stringi::stri_trans_general(clean_text, "Latin-ASCII"),
      clean_text = iconv(clean_text, from = "latin1", to = "ASCII", sub = ""),
      clean_text = str_replace_all(clean_text, "[ \t]{2,}", " "), # Espacios
      clean_text = str_replace_all(clean_text, "^\\s+|\\s+$", ""),
      clean_text = str_replace_all(clean_text, "[[:punct:]]", ""),
      clean_text = str_replace_all(clean_text, "[[:digit:]]", ""),
      clean_text = str_to_lower(clean_text)
    ) %>% 
    mutate(text_plane = convert_emoji(text)) 
  
  
  # Obtenemos los tweets que poseen los emojis que nos interesan
  
  emoji_tweets <- 
    tidy_tweets %>% 
    filter(str_detect(text, regex(emojis_find))) %>% 
    mutate(
      emoji = str_extract(text, regex(emojis_find)) #%>% 
      #as_data_frame %>% 
      #unite(emojis, sep = "", remove = T) %>% 
      #pull(emojis)#,
      #n_emojis = str_length(emojis)
    ) %>% 
    left_join(
      emojis_m,
      by = c("emoji" = "code")
    ) %>% 
    select(clean_text, clave) 
  
  return(emoji_tweets)
}

data_tweets_emojis <- 
  emojis_m$code %>% 
  map_dfr(get_clean_tweets)

data_tweets_emojis %>% 
  write_csv("train-emoji-2.csv")


read_csv("train-emoji.csv") %>% 
  full_join(
    read_csv("train-emoji-2.csv")
  ) %>% 
  distinct() %>% 
  write_csv("train-emoji-3.csv")
  
