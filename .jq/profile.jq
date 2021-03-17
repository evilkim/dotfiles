#!jq
#
# REFERENCES
# * https://gist.github.com/mikehwang/6ed95480579ac0b9fd72bff340d99a18
#
# Example usage:
# jq 'include "profile"; profile_object' {{JSON_FILE}}

module {
  "name": "profile",
  "description": "Profile JSON schema",
  "homepage": "https://gist.github.com/mikehwang/6ed95480579ac0b9fd72bff340d99a18",
};

def profile_object:
    to_entries | def parse_entry: {"key": .key, "value": .value | type}; map(parse_entry)
        | sort_by(.key) | from_entries;

def profile_array_objects:
    map(profile_object) | map(to_entries) | reduce .[] as $item ([]; . + $item) | sort_by(.key) | from_entries;

def profile_array_objects_with_freq:
    map(profile_object) | map(to_entries) | flatten | group_by(.key)
        | def create_profile_entry:
            {"key": .[0] | .key, "value": { "count": . | length, "type": .[0] | .value }};
        map(create_profile_entry) | from_entries;
