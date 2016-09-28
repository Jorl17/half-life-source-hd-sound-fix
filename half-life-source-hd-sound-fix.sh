#!/bin/bash -e
##
## Copyright (C) 2016 João Ricardo Lourenço <jorl17.8@gmail.com>
##
## Github: https://github.com/Jorl17
##
## Project main repository: https://github.com/Jorl17/half-life-source-hd-sound-fix
##
## This file is part of half-life-source-hd-sound-fix.
##
## half-life-source-hd-sound-fix is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 2 of the License, or
## (at your option) any later version.
##
## half-life-source-hd-sound-fix is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with half-life-source-hd-sound-fix.  If not, see <http://www.gnu.org/licenses/>.
##
#
#
# This script fixes missing weapon and reloading sounds in Half-Life: Source when using HD textures/models. It:
# 1. Extracts hl1_hd_pak_dir.vpk
# 2. Moves the extracted sounds folder to the appropriate place (can also move all files)
# 3. Downloads Fixed HD models (for reloading sounds) from https://www.dropbox.com/s/k5ziho54lhtv0xr/hl1-source-hd-models-fixed-04_23_16.zip?dl=0
# 4. Places these models in the appropriate places
#
# The hard part of this script was described by https://github.com/malortie in https://github.com/ValveSoftware/Source-1-Games/issues/1345.

# false = move only the sounds folder; true = move everything
MOVE_EVERYTHING=false

# So we know where we are
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source of fixed models (see https://github.com/ValveSoftware/Source-1-Games/issues/1345)
FIXED_MODELS_URL="https://www.dropbox.com/s/k5ziho54lhtv0xr/hl1-source-hd-models-fixed-04_23_16.zip?dl=0"

# Change these variables if needed. Note that we currently do not provide a VPK linux32 binary.

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    STEAMAPPS=~/.steam/steam/steamapps/    
    VPK_FOLDER="$STEAMAPPS/common/Half-Life 2/bin"
    VPK_BINARY="vpk_linux32"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    STEAMAPPS=~/"Library/Application Support/Steam/SteamApps/"
    VPK_FOLDER="$SCRIPT_DIR/vpk-bin"
    VPK_BINARY="vpk_osx32"
fi

HL2_FOLDER="$STEAMAPPS/common/Half-Life 2/"
HL1_HD_FOLDER="$HL2_FOLDER/hl1_hd"

# Extract hl1_hd_pak_dir.vpk (need to override dynamic library paths)
echo "[SCRIPT] Extracting hl1_hd_pak_dir.vpk..."
cd "$HL1_HD_FOLDER"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:"$VPK_FOLDER" "$VPK_FOLDER"/"$VPK_BINARY" ./hl1_hd_pak_dir.vpk
elif [[ "$OSTYPE" == "darwin"* ]]; then
    DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:"$VPK_FOLDER" "$VPK_FOLDER"/"$VPK_BINARY" ./hl1_hd_pak_dir.vpk
fi

echo "[SCRIPT] Moving extracted files..."
# Move the right files to the right places and cleanup
if [ "$MOVE_EVERYTHING" = true ] ; then
    mv hl1_hd_pak_dir/* ./
else
    mv hl1_hd_pak_dir/sound ./
fi
rm -rf hl1_hd_pak_dir

# Download fixed HD models (if needed)
if [ ! -f "hl1-source-hd-models-fixed.zip" ]; then
    echo "[SCRIPT] Downloading hl1-source-hd-models-fixed.zip..."
    curl -L -o "hl1-source-hd-models-fixed.zip" "$FIXED_MODELS_URL"    
else
    echo "[SCRIPT] Using available hl1-source-hd-models-fixed.zip..."
fi

echo "[SCRIPT] Extracting hl1-source-hd-models-fixed.zip..."
unzip "hl1-source-hd-models-fixed.zip"


# Move the fixed HD models to the right place and cleanup
echo "[SCRIPT] Moving fixed HD models..."
if [ ! -d "models" ]; then
  mkdir models
fi
mv hl1-source-hd-models-fixed*/* models/
rm -rf "hl1-source-hd-models-fixed"*

echo "[SCRIPT] All done! Enjoy your Half-Life: Source with HD Textures and Models! Now with sound!"
