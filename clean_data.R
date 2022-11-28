soundFilePath <- "/Volumes/data/projects/time/time_followup/data"
soundFilePath1 <- "/Volumes/data/projects/time/time_exp1/data/child"
outSoundPath <- "/Volumes/data/projects/time/analysis/clean_data"
monoleft_path <- "/Volumes/data/projects/time/analysis/mono_left"

textPath1 <- "/Volumes/data/projects/time/time_followup/transcription/emily"
textPath2 <- "/Volumes/data/projects/time/time_followup/transcription/kate"
textPath3 <- "/Volumes/data/projects/time/time_exp1/transcription/emily"
textPath4 <- "/Volumes/data/projects/time/time_exp1/transcription/kate"
textPath5 <- "/Volumes/data/projects/time/time_followup/transcription/sarah"
outTextPath <- "/Volumes/data/projects/time/analysis/clean_transcription"


# Delete the data that have been extracted mono left channel of sounds off the clean_data folder to avoid duplicated data on NAS
cleandataFile <- list.files(outSoundPath)
monoLeftFile <- list.files(monoleft_path)

if(length(cleandataFile[which(cleandataFile %in% monoLeftFile)]) != 0) {
  remvFileList <- paste0(outSoundPath, "/", cleandataFile[which(cleandataFile %in% monoLeftFile)])
  print(remvFileList)
  file.remove(remvFileList)
}


# Clean the naming of the two-channel original .wav files for the followup Exp and copy them to the clean_data folder
setwd(soundFilePath)

d <- list.files(pattern = "*wav")

d <- as.character(d)

library(stringr)
newName <- str_extract(d, "(spoli|blast|smile|undefined)\\S+_rsr(1|2)\\S+.wav")

d[which(is.na(newName))]

file.copy(from = soundFilePath, to = outSoundPath)

file.rename(from = file.path(outSoundPath, d), 
            to = file.path(outSoundPath, newName))


# # Clean the naming of the two-channel original .wav files for the orginal Exp and copy them to the clean_data folder
setwd(soundFilePath1)

d <- list.files(pattern = "*wav")

d <- as.character(d)

library(stringr)
newName <- str_extract(d, "(spoli|blast|smile|undefined)\\S+_rsr(1|2)\\S+.wav")

d[which(is.na(newName))]

file.copy(from = soundFilePath1, to = outSoundPath)

file.rename(from = file.path(outSoundPath, d), 
            to = file.path(outSoundPath, newName))





# Clean the naming of the manual transcription .TextGrid files and copy them to the clean_transcription folder

clean_transcription <- function(path) {
  
  setwd(path)
  print(path)
  
  d <- list.files(pattern = "*TextGrid")
  
  d <- as.character(d)
  
  library(stringr)
  newName <- str_extract(d, "(spoli|blast|smile|undefined)\\S+_rsr(1|2)\\S+.TextGrid")
  
  d[which(is.na(newName))]
  
  file.copy(from = file.path(path, d), to = file.path(outTextPath, d), overwrite = F)
  
  file.rename(from = file.path(outTextPath, d), 
              to = file.path(outTextPath, newName))
}

clean_transcription(textPath1)
clean_transcription(textPath2)
clean_transcription(textPath3)
clean_transcription(textPath4)
clean_transcription(textPath5)

# Only need to do this once for previously transcribed files for which the .Textgrid was unfortunately not saved
# setwd("/Volumes/data/projects/time/time_exp1/transcription/veronica/")
# 
# d <- list.files(pattern = "*txt")
# 
# d <- as.character(d)

# 
# file.copy(from = file.path("/Volumes/data/projects/time/time_exp1/transcription/veronica", d), 
#           to = file.path("/Volumes/data/projects/time/analysis/temp", d), overwrite = T)

# trim_name <- str_remove(d, ".txt")
# 
# all_analyzed <- list.files("/Volumes/data/projects/time/analysis/mono_left/")
# 
# all_analyzed <- as.data.frame(all_analyzed)
# 
# all_analyzed$trim_name <- str_extract(all_analyzed$all_analyzed, "\\S+(?=\\.)")
# 
# all_analyzed$trim_name <- str_extract(all_analyzed$trim_name, "\\S+(2020|2021|2022)")
# 
# all_analyzed[which(all_analyzed$trim_name %in% trim_name), "new_transcription"] <- "yes"
# 
# filtered <-
#   all_analyzed %>%
#   filter(new_transcription == "yes") %>%
#   filter(!str_detect(all_analyzed, ".wav"))
# 
# file.rename(from = file.path("/Volumes/data/projects/time/analysis/mono_left", filtered$all_analyzed), 
#             to = file.path("/Volumes/data/projects/time/analysis/mono_left/brooke_transcription_output", filtered$all_analyzed))
# 
# all_transcription <- list.files("/Volumes/data/projects/time/analysis/temp")
# 
# filterd_transcription <- filtered[which(filtered$all_analyzed %in% all_transcription),]
# 
# file.rename(from = file.path("/Volumes/data/projects/time/analysis/temp", filterd_transcription$all_analyzed), 
#             to = file.path("/Volumes/data/projects/time/analysis/mono_left", filterd_transcription$all_analyzed))

