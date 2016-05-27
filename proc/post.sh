#!/usr/bin/env bash

cd module

# Delete autogenerated onClickUserLogin definition.
# Overriden in "logic/user-tab-validation.bsh".
string="
onClickUserLogin () {
  \/\/ TODO: Add some things which should happen when this element is clicked
  newTab(\"Control\", true);
}"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Delete autogenerated onClickContextUpdateTexture definition.
# Overriden in "logic/texture-helper.bsh".
string="
onClickContextUpdateTexture () {
  \/\/ TODO: Add some things which should happen when this element is clicked
  newTab(\"Context\/Deposit\", true);
}"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Delete autogenerated onClickContextCloseContextandReview definition.
# Overriden in "logic/close-context-and-review-button.bsh".
string="
onClickContextCloseContextandReview () {
  \/\/ TODO: Add some things which should happen when this element is clicked
  newTab(\"Context\/Review\", true);
}"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Delete autogenerated onClickContextTextureHelper definition.
# Overriden in "logic/texture-helper.bsh".
string="
onClickContextTextureHelper () {
  \/\/ TODO: Add some things which should happen when this element is clicked
  newTab(\"Context\/Texture_Helper\", true);
}"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# I hate this regex so much. Anyway, what it does is match everything in the
# function definition of `newContext`, including the name, parens and opening
# curly brace, but excluding the closing curly brace. This allows us to stick
# a line right before the closing curly brace.
string="(newContext\\(\\){((?!\\n}).)+)"
replacement="\\1
  copyExcavators();
  copyMeshSize();
  copyTargetSpitThickness();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

string="(newPhotographLog\\(\\){((?!\\n}).)+)"
replacement="\\1
  copyPhotographLogLotId();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

string="(newArtefactGroup\\(\\){((?!\\n}).)+)"
replacement="\\1
  copyArtefactLotId();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

string="(newSpecialFind\\(\\){((?!\\n}).)+)"
replacement="\\1
  copySpecialFindLotId();"
perl -0777 -i.original -pe "s/$string/$replacement/igs" ui_logic.bsh

# Delete autogenerated loadContextFrom definition.
# Overriden in "logic/lot-label-population.bsh".
string="
loadContextFrom(String uuid) {
  String tabgroup = \"Context\";
  setUuid(tabgroup, uuid);
  if (isNull(uuid)) return;

  showTabGroup(tabgroup, uuid);
}"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Notify the current user if they try to add relationships to the current
# context without having saved it first
string="
  newTab(\"Context_Group_Relationship\", true);"
replacement="
  String tabgroup = \"Context_Group\";
  if (isNull(getUuid(tabgroup))){
    showToast(\"{You_must_save_this_tabgroup_first}\");
    return;
  }
  $string"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Notify the current user if they try to add relationships to the current
# context without having saved it first
string="
  newTab(\"Relationship\", true);"
replacement="
  String tabgroup = \"Context\";
  if (isNull(getUuid(tabgroup))){
    showToast(\"{You_must_save_this_tabgroup_first}\");
    return;
  }
  $string"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Code to inherit LOT_ID from Context into Sample
string="
  parentTabgroup = tabgroup;
  newSample();"
replacement="
  parentTabgroup   = tabgroup;
  parentTabgroup__ = tabgroup;
  newSample();
  if (parentTabgroup__.equals(\"Context\"))
      copyLotId();"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Remove duplicate dubtton from swipe menu
string="
  removeNavigationButton(\"duplicate\");"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh
string="
  addNavigationButton(\"duplicate\", new ActionButtonCallback() {
    actionOnLabel() {
      \"{Duplicate}\";
    }
    actionOn() {
      if(!isNull(getUuid(tabgroup))) {
          duplicateRecord(tabgroup);
      } else {
          showWarning(\"{Warning}\", \"{This_record_is_unsaved_and_cannot_be_duplicated}\");
      }
    }
  }, \"primary\");"
replacement=""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_logic.bsh

# Link Start_Depth_Magnitude to data schema as measure
string="<input ref=\"Start_Depth_Magnitude\""
replacement="$string faims_attribute_name=\"Start Depth\" faims_attribute_type=\"measure\""
perl -0777 -i.original -pe "s/\\Q$string/$replacement/igs" ui_schema.xml

# Change the style of this column to be skinner than the others. This is
# intended to apply to the "Review" tab in "Control", but there's not much
# enforcing that... Note that this match is NOT global, unlike the others in
# this script.
string="<group ref=\"Col_1\" faims_style=\"even\">"
replacement="<group ref=\"Col_1\" faims_style=\"large\">"
perl -0777 -i.original -pe "s/\\Q$string/$replacement/is" ui_schema.xml

rm ui_logic.bsh.original
rm ui_schema.xml.original
