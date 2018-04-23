
# Objetivo ----------------------------------------------------------------

# Obtener tweets con un solo emoticón

# Paquetes ----------------------------------------------------------------

pacman::p_load(tidyverse, rtweet, tidytext, install = F) # Si no se tienen los paquetes
                                               # Cambiar a install = F



# Api twitter -------------------------------------------------------------

# Nombre
appname <- "tweets-emojis"

# Key
key <- #POner

# Secret
secret <- #Poner

# Token
twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret)


# Datos de emojis ---------------------------------------------------------

emojis_m <- rtweet::emojis %>% 
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
  iconv(emoji, from = "latin1", to = "ascii", sub = "byte")
}

# Función para reconvetir emojis
reconvert_emoji <- function(emoji){
  iconv(emoji, from = "ascii", to = "latin1", sub = "byte")
}

# Emojis para filtrar,
# los que se acordaron en github
emojis_find <- emojis_m %>% 
  pull(code) %>% 
  str_c(collapse = "|")

# Emojis totales
emojis_tot <- emojis %>% 
  pull(code) %>% 
  convert_emoji %>% 
  str_c(collapse = "|")



# Obtención de tweets -----------------------------------------------------

raw_tweets <- search_tweets(
    "#", n = 18000, lang = "es",  include_rts = F, 
    retryonratelimit = T
  )


# Mmodificamos los tweets -------------------------------------------------

tidy_tweets <- raw_tweets %>% 
  mutate_at(
    vars(text),
    ~str_replace_all(., "https://t.co/[A-Za-z\\d]+|http://[A-Za-z\\d]+|&amp;|&lt;|&gt;|RT|https|@\\w+|#\\w+", "")
  ) %>% 
  mutate(text_plane = convert_emoji(text))

# Obtenemos los tweets que poseen los emojis que nos interesan

tidy_tweets %>% 
  filter(str_detect(text, regex(emojis_find))) %>% 
  mutate(
    text_sin_emojis = str_remove_all(text_plane, regex(emojis_find)),
    emojis = str_extract_all(text, regex(emojis_find), simplify = T) %>% 
      as_data_frame %>% 
      unite(emojis, sep = "", remove = T) %>% 
      pull(emojis),
    n_emojis = str_length(emojis)
  ) %>% 
  select(original = text, text_sin_emojis, emojis, n_emojis) %>% 
  mutate(text_clean = reconvert_emoji(text_sin_emojis)) %>% 
  filter(!n_emojis > 1) %>% 
  full_join(
    emojis_m,
    by = c("emojis" = "code")
  ) %>% 
  drop_na %>% 
  select(text_clean, clave) %>% 
  write_csv("../../data/train_tweets.csv")
