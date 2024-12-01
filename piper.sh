#!/bin/bash

if [ -t 0 ]; then
    # Interactive mode - no pipe
    # Select language using gum choose
    LANGUAGE=$(gum choose "English" "German")

    # Get the text to speak
    TEXT=$(gum input --width 50 --placeholder "What should I say?")
else
    # Pipe mode - read from stdin
    TEXT=$(cat)
    # Check for --german flag in pipe mode
    if [[ "$*" == *"--german"* ]]; then
        LANGUAGE="German"
    else
        LANGUAGE="English"
    fi
fi

# Build the command based on language
if [ "$LANGUAGE" = "English" ]; then
    CMD="echo \"$TEXT\" | docker run --rm -i piper-tts --model en_GB-cori-high.onnx --length_scale 1.0 --sentence_silence 0.5 --output_raw | sox -t raw -r 22050 -b 16 -e signed-integer -c 1 - -d"
else
    CMD="echo \"$TEXT\" | docker run --rm -i piper-tts --model de_DE-thorsten-high.onnx --length_scale 1.4 --sentence_silence 0.5 --output_raw | sox -t raw -r 22050 -b 16 -e signed-integer -c 1 - -d"
fi

# Run the command with a spinner
gum spin --spinner dot --title "Speaking..." -- bash -c "$CMD"
