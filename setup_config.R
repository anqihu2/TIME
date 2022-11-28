# Transform ProsodyPro output files to txt files:
# Move the Prosody Output to some individual folders and read the files below from FAVE-extract/part_id
wkDir <- "/Volumes/data/projects/time/analysis/mono_left"

# Set up config files for FAVE Extract:------------------------------------------------------------------------------------------------

emptySpeaker <- read.table("/Volumes/data/projects/time/analysis/speakerfile.txt")

pitchFile <- list.files(path = wkDir, pattern = "*.wav")

pitchFile <- data.frame(pitchFile)

pitchFile$fileName <- pitchFile$pitchFile

pitchFile$pitchFile <- str_extract(pitchFile$pitchFile, "(spoli|blast|smile)\\S+(?=_rsr(1|2)\\S+.wav)")

# if(length(which(str_detect(pitchFile$pitchFile, "followup"))) > 0) {
#   pitchFile$pitchFile <- str_extract(pitchFile$pitchFile, "(spoli|blast|smile)_c_\\S{3}_followup")
# }

pitchFile <- pitchFile[which(!is.na(pitchFile$pitchFile)),]

colnames(pitchFile)[which(colnames(pitchFile) == "pitchFile")] <- "part_id"

demo <- read.csv("/Volumes/data/projects/time/analysis/demo/rsr_age.csv")[,c("part_id", "gender", "age_rsr_year")]

pitchFile <- merge(pitchFile, demo, by.x = "part_id", by.y = "part_id", all.x = T)

pitchFile$age_rsr_year <- as.numeric(as.character(pitchFile$age_rsr_year))

pitchFile$part_id <- 1

pitchFile$fileName <- str_extract(pitchFile$fileName, "(spoli|blast|smile)\\S+_rsr(1|2)\\S+(?=.wav)")

# Change subject IDs here to add speaker files------------------------------------------------------------------------------------------------------------------------------
# pitchFile <- unique(pitchFile[which(str_detect(pitchFile$fileName, c("smile_c_009|smile_c_010|smile_c_011|smile_c_012|smile_c_013"))),])

colnames(pitchFile) <- c("--speakernum", "--name", "--sex",  "--age")

colLong <- data.frame(newcol = c(t(pitchFile)), stringsAsFactors=FALSE)

speakerFCol <- rep(c("--speakernum", "--name", "--sex",  "--age"), times = nrow(colLong)/4)

colLong <- cbind(speakerFCol, colLong)

library("dplyr")
library("tidyr")

colLong <- 
  colLong %>%
  pivot_longer(everything()) %>%
  select(!name)

colLong <- data.frame(colLong)

seqNum <- sort(c(seq(1,nrow(colLong),8), seq(8,nrow(colLong),8)))

# length(seqNum)

for (i in 1:length(seqNum)) {
  if(i %% 2 == 1) {
    tempTable <- colLong[c(seqNum[i]:seqNum[i+1]),]
    tempFileName <- paste0(tempTable[4], "_config.speaker")
    wkDirFull <- paste0(wkDir, "/")
    write.table(tempTable, paste0(wkDirFull, tempFileName),sep="\t", col.names = F, row.names = F, quote = FALSE)
  }
}

