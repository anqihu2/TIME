# TIME


## Time Analysis Pipeline

## Step 1: Clean/ Rename the downloaded data and move them to the data folder
```bash
cd Documents/Time/scripts
Rscript clean_data.R
```
From here on, all the analyses sound/ wav files, txt, TextGrid should be in the same directory (now, FAVE-align, prosodyPro will break if they are not.)

## Step 2: Extract the left channel of the sound files

```bash
python3
```
```python
import parselmouth

parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/read_file.praat','/Volumes/data/projects/time/time_exp1/data/child/','.wav','/Volumes/data/projects/time/analysis/mono_left','/Volumes/data/projects/time/analysis/mono_right')
```
parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/read_file.praat','/Volumes/data/projects/time/analysis/clean_data','.wav','/Volumes/data/projects/time/analysis/mono_left','/Volumes/data/projects/time/analysis/mono_right')




## Step 3: Manual annotation of data in Praat 

Manual annotation


## Step 4: Extract Praat annotation into FAVE output 

Input files in the command below: (Convert_To_FAVE-align_Input_Left.praat script; where the manually transcribed TextGrids are located; where to save the fave-formatted text files, input file format):


```python
import parselmouth
parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/Convert_To_FAVE-align_Input_Left.praat',
'/Volumes/data/projects/time/analysis/clean_transcription','/Volumes/data/projects/time/analysis/temp/','.TextGrid')



# Move the .txt files that are not in mono_left folder yet from the temp folder to the mono_left folder or replace all the .txt files in there if transcriptions were redone
import os
import shutil
for file in os.listdir('/Volumes/data/projects/time/analysis/temp/'):
  if not os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/', file)):
      shutil.move(os.path.join('/Volumes/data/projects/time/temp/', file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/', file))
```



## Step 5: Force align the annotated data for children (FAVE Align)

Input files in the commands below:(.txt file converted from manually annotated TextGrid; mono_left sound file; Arphabet dictionary.txt for unknown words)

**It is very important that python2 is used to run FAVE, python3 does not work currently.**

While running this script, there will be things to enter in Terminal, expect to skip unknown words during force-align.

```bash
# loop through every file in the given directory and force-align the wav file and txt file with the same name:
# FAAValgn.py ".wav file name" ".txt name of fave-formatted manual transcriptions" "output file names with _phone_word.TextGrid as suffix"
cd /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/

for i in /Volumes/data/projects/time/analysis/mono_left/*.txt; do
  if [ -f ${i/.txt/_phone_word.TextGrid} ]; then
    echo "File existed; Skip force-alignment."
  else
    python2 /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/FAAValign.py "${i/.txt/.wav}" "$i" "${i/.txt/_phone_word.TextGrid}"; \
  fi
done
```

## If the immediately preceding chunk takes too long to loop through, use this to run individual subjects:
python2 /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/FAAValign.py /Volumes/data/projects/time/analysis/mono_left/spoli_c_644_rsr2_mar172021.wav /Volumes/data/projects/time/analysis/mono_left/spoli_c_644_rsr2_mar172021.txt /Volumes/data/projects/time/analysis/mono_left/spoli_c_644_rsr2_mar172021_phone_word.TextGrid

## Step 5.1: Force align the annotated data for model talkers 

Recycle step 5 with just the model talkers' audio files. May be combined into one step with step 5.

## Step 6: Extract pitch values (prosodypro)

## Step 6.1: Extract the phone level TextGrid for participants 

```python
# Move the files phone level textfrids that are not tier-removed to a temp folder
import os
import re
import shutil

for file in os.listdir('/Volumes/data/projects/time/analysis/mono_left/'):
  if file.endswith("_phone_word.TextGrid"):
  # Get rid of .Textgird file suffix, check file_phone_word.txt existence:
    mod_file = re.sub("_phone_word.TextGrid", '_phone.TextGrid',file)
    if not os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/', mod_file)):
       shutil.copy(os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid_temp/',file))
```

```python
import parselmouth

parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/remove_textgrid_tier.praat',
'/Volumes/data/projects/time/analysis/mono_left/phone_textgrid_temp', 1, 2, '/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/')
```

```python
# Remove everything in the phone_textgrid_temp directory to avoid duplicated .TextGrid files on NAS
import os
import glob

files = glob.glob('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid_temp/*')
for f in files:
    os.remove(f)
```

```python
# Copy the phone level TextGrid files that are tier-removed to the mono_left folder for prosody pro analysis later; still need to keep them in the phone_textgrid folder for sentence matching analyses later
import os
import re
import shutil

for file in os.listdir('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/'):
  if file.endswith("_phone.TextGrid"):
  # Get rid of .Textgird file suffix, check file_phone_word.txt existence:
    if not os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/', file)):
       shutil.move(os.path.join('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/',file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file))
```




## Step 6.2: Extract the phone level ProsodyPro pitch


```python
# Remove the .wav files that are already done with ProsodyPro analyses in the directory temporarily so that ProsodyPro doesn't need to be run again:
import os
import re
import shutil

for file in os.listdir('/Volumes/data/projects/time/analysis/mono_left/'):
  if file.endswith(".wav"):
    mod_file = re.sub(".wav", '.actutimenormf0',file)
    txt_file = re.sub(".wav", '.txt',file)
  # Get rid of .Textgird file suffix, check file_phone_word.txt existence:
    if os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/', mod_file)):
      shutil.move(os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/wav_temp',file))
    # Or if the .wav file has not been transcribed; move it to not_transcribed folder
    if not os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/', txt_file)):
      shutil.move(os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file),os.path.join('/Volumes/data/projects/time/analysis/not_transcribed/',file))
    
```

**Now, open the prosodyPro script (our customized version: _ProsodyPro_modified_phone_level.praat') and run it**

To download the original prosodyPro script: http://www.homepages.ucl.ac.uk/~uclyyix/ProsodyPro/

While running this script, there will be things to enter in popped-up Praat window, expect to click "Next" for the script to loop through subjects.








## Step 6.3: Process demographic information for RSR tasks
```bash
Rscript -e "rmarkdown::render('/Users/jojohu/Documents/Time/scripts/rsr_demo.Rmd')"
```




## Step 6.4: Reformat the ProsodyPro output to txt (to match pitch analyses files with formant analyses files) and set up speaker files (with demo) for FAVE Extract
```bash
Rscript /Users/jojohu/Documents/Time/scripts/setup_config.R
```


## Step 7: Extract formant values (Fave Extract)

Input files in the command below: (.speaker file with unidentifiable demo; force aligned TextGrid; mono .wav file)

```bash
cd /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-extract

for i in /Volumes/data/projects/time/analysis/mono_left/*.wav; do
  if [ -f ${i/.wav/_output_norm.txt} ]; then
    echo "File existed; Skip force-extract."
  else
    python2 /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-extract/bin/extractFormants.py --speaker "${i/.wav/_config.speaker}" "$i" "${i/.wav/_phone_word.TextGrid}" "${i/.wav/_output}"; \
  fi
done
```
FAVE Extract Code: https://groups.google.com/g/fave-users/c/a3T4xE6x88k/m/tCISVsxIDQAJ
python extractFormants.py -s speaker.speakerfile sound.wav tg.TextGrid output
python extractFormants.py --speaker speaker.speakerfile sound.wav tg.TextGrid output

```python
# Put back the .wav files that are already done with ProsodyPro and FAVE-extract analyses into the mono_left directory
import os
import shutil

for file in os.listdir('/Volumes/data/projects/time/analysis/mono_left/wav_temp/'):
  if file.endswith(".wav"):
    shutil.move(os.path.join('/Volumes/data/projects/time/analysis/mono_left/wav_temp/',file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file))
```



## Step 8: Align sentence numbers with forced aligned output

```python
# Move the files phone_word level textfrids that are not FAVE-format converted to a temp folder 
import os
import re
import shutil

for file in os.listdir('/Volumes/data/projects/time/analysis/mono_left/'):
  if file.endswith("_phone_word.TextGrid"):
  # Get rid of .Textgird file suffix, check file_phone_word.txt existence:
    mod_file = re.sub(".TextGrid", '.txt',file)
    if not os.path.exists(os.path.join('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/', mod_file)):
       shutil.copy(os.path.join('/Volumes/data/projects/time/analysis/mono_left/',file),os.path.join('/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/',file))
# /Volumes/data/projects/time/analysis/mono_left/phone_textgrid_temp/

# Convert the forced-aligned output to txt files
# Extremely slow when run on NAS
import parselmouth

parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/Convert_To_FAVE-align_Input_Left_phone_word.praat',
'/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/','/Users/jojohu/Documents/Time/data/mono_right', '_phone_word.TextGrid', '', 
'/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/')

# Move it locally to NAS
for file in os.listdir('/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/'):
  if file.endswith("_phone_word.txt"):
  # Get rid of .Textgird file suffix, check file_phone_word.txt existence:
    shutil.move(os.path.join('/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/',file),os.path.join('/Volumes/data/projects/time/analysis/mono_left/phone_textgrid/',file))
```

```bash
# Align the sentence number to the data
Rscript -e "rmarkdown::render('/Users/jojohu/Documents/Time/scripts/sound_preprocess.Rmd')"
```

```python
# Remove everything in the phone_textgrid_temp directory to avoid duplicated .TextGrid files on NAS
import os
import glob

files = glob.glob('/Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align/temp/*')
for f in files:
    os.remove(f)
```

## Step 9: Repeat analysis with right channel data
