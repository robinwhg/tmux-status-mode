#!/usr/bin/env bash

set -e

# Possible configurations for colors
declare -r normal_mode_color_config="@normal_mode_color"
declare -r prefix_mode_color_config="@prefix_mode_color"
declare -r copy_mode_color_config="@copy_mode_color"
declare -r sync_mode_color_config="@sync_mode_color"
declare -r nested_mode_color_config="@nested_mode_color"

# Possible configurations for section content
declare -r section_a_config="@section_a"
declare -r section_b_config="@section_b"
declare -r section_c_config="@section_c"
declare -r section_x_config="@section_x"
declare -r section_y_config="@section_y"
declare -r section_z_config="@section_z"

# Default colors
declare -r normal_mode_color_default="blue"
declare -r prefix_model_color_default="green"
declare -r copy_mode_color_default="magenta"
declare -r sync_mode_color_default="cyan"
declare -r nested_mode_color_default="red"

# Default section content
declare -r section_a_default=" Section A "
declare -r section_b_default=" Section B "
declare -r section_c_default=" Section C "
declare -r section_x_default=" Section X "
declare -r section_y_default=" Section Y "
declare -r section_z_default=" Section Z "

get_option_value() {
  local -r config=$(tmux show-option -gqv "$1")
  local -r default="$2"
  echo "${config:-$default}"
}

get_mode_color() {
  local -r \
    normal_mode_color="$(get_option_value "$normal_mode_color_config" "$normal_mode_color_default")" \
    prefix_mode_color="$(get_option_value "$prefix_mode_color_config" "$prefix_model_color_default")" \
    copy_mode_color="$(get_option_value "$copy_mode_color_config" "$copy_mode_color_default")" \
    sync_mode_color="$(get_option_value "$sync_mode_color_config" "$sync_mode_color_default")" \
    nested_mode_color="$(get_option_value "$nested_mode_color_config" "$nested_mode_color_default")"

  echo "#{?#{==:#{client_key_table},off},$nested_mode_color,#{?synchronize-panes,$sync_mode_color,#{?client_prefix,$prefix_mode_color,#{?pane_in_mode,$copy_mode_color,$normal_mode_color}}}}"
}

main() {
  local -r \
    section_a="#[fg=black,bg=$(get_mode_color)]$(get_option_value "$section_a_config" "$section_a_default")" \
    section_b="#[fg=$(get_mode_color),bg=brightblack]$(get_option_value "$section_b_config" "$section_b_default")" \
    section_c="#[fg=white,bg=black]$(get_option_value "$section_c_config" "$section_c_default")" \
    section_x="#[fg=white,bg=black]$(get_option_value "$section_x_config" "$section_x_default")" \
    section_y="#[fg=$(get_mode_color),bg=brightblack]$(get_option_value "$section_y_config" "$section_y_default")" \
    section_z="#[fg=black,bg=$(get_mode_color)]$(get_option_value "$section_z_config" "$section_z_default")"

  tmux set-option -gq status-left "$section_a$section_b$section_c"
  tmux set-option -gq status-right "$section_x$section_y$section_z"
}

main
