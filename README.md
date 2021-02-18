# TIME


## Time Analysis Pipeline

## Step 1: Clean/ Rename the downloaded data and move them to the data folder
```bash
cd Documents/Time/scripts
Rscript clean_data.R
```
## Step 2: Extract the left channel of the sound files
To DO: Still cannot load the objects into Praat object window directly, need to test if the mono channel extraction is automated in this step:
```bash
python3
```
```python
import parselmouth

parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/read_file.praat',
'/Users/jojohu/Documents/Time/data/mono_left','/Users/jojohu/Documents/Time/data/mono_right','.wav')
```

No need to use praat wrapper? Call praat directly in terminal?

## Step 3: Manual annotation of data in Praat 

To DO: Need to decide how the annotation for model talker should be included: separate tiers for model talkers and children?


## Step 4: Extract Praat annotation into FAVE output 

using Convert_To_FAVE-align_Input.praat (2 To Dos in this praat scrip)

Input files in the command below: (Convert_To_FAVE-align_Input_Left.praat script; mono left sound file):

No need to use parselmouth? Directly call praat script in terminal with the same arguments?

```python
parselmouth.praat.run_file('/Users/jojohu/Documents/Time/praat_script/Convert_To_FAVE-align_Input_Left.praat',
'/Users/jojohu/Documents/Time/data/mono_left','/Users/jojohu/Documents/Time/data/mono_right','.wav')
```

If model talker annotation is included, then remove the model talker tier before force align or force align for different tiers

## Step 5: Force align the annotated data for children (FAVE Align)

Input files in the commands below:(.txt file converted from manually annotated TextGrid; mono_left sound file; Arphabet dictionary.txt for unknown words)

```bash
cd /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-align

python(...)
```

## Step 5.1: Force align the annotated data for model talkers 

May be combined into one step with above.

To DO: Set up the .speaker file for every participant in a R script (due to the identifiable demo info from RedCap)

## Step 6: Extract formant values (Fave Extract)

To DO: Set up a for loop for the command below in terminal through python; examine the tiers being extracted if child and model talker tiers are both in the force aligned TextGrid

Input files in the command below: (.speaker file with unidentifiable demo; force aligned TextGrid; mono .wav file)

```bash
cd /Users/jojohu/Documents/Time/FAVE-1.2.3/FAVE-extract
python bin/extractFormants.py --speaker part_id.speaker part_id_task.wav part_id_task.TextGrid part_id_outputFile
```

## Step 7: Extract pitch values (prosodypro?)

## Step 8: Repeat analysis with right channel data
