#!/usr/bin/env bash

set -e

# Mode indicator
declare -r \
  mode_indicator_placeholder="\#{mode_indicator}" \
  normal_mode_indicator_config="@normal_mode_indicator" \
  prefix_mode_indicator_config="@prefix_mode_indicator" \
  copy_mode_indicator_config="@copy_mode_indicator" \
  sync_mode_indicator_config="@sync_mode_indicator" \
  nested_mode_indicator_config="@nested_mode_indicator" \
  normal_mode_indicator_default="TMUX" \
  prefix_mode_indicator_default="WAIT" \
  copy_mode_indicator_default="COPY" \
  sync_mode_indicator_default="SYNC" \
  nested_mode_indicator_default="NEST"

# Mode colors
declare -r \
  mode_color_placeholder="\#{mode_color}" \
  normal_mode_color_config="@normal_mode_color" \
  prefix_mode_color_config="@prefix_mode_color" \
  copy_mode_color_config="@copy_mode_color" \
  sync_mode_color_config="@sync_mode_color" \
  nested_mode_color_config="@nested_mode_color" \
  normal_mode_color_default="blue" \
  prefix_model_color_default="green" \
  copy_mode_color_default="magenta" \
  sync_mode_color_default="cyan" \
  nested_mode_color_default="red"

# Section content
declare -r \
  section_a_config="@section_a" \
  section_b_config="@section_b" \
  section_c_config="@section_c" \
  section_x_config="@section_x" \
  section_y_config="@section_y" \
  section_z_config="@section_z" \
  section_a_default=" ${mode_indicator_placeholder:1} " \
  section_b_default=" #S " \
  section_c_default="" \
  section_x_default=" \"#{=22:pane_title}\" " \
  section_y_default=" %H:%M " \
  section_z_default=" %d-%b-%y "

# Section separators
declare -r \
  separator_left_config="@separator_left" \
  separator_right_config="@separator_right" \
  separator_left_default="" \
  separator_right_default=""

# Section color
declare -r \
  section_by_bg_config="@section_by_bg" \
  section_by_bg_default="brightblack"

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
    separator_ab="#[fg=$(get_mode_color),bg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default")]$(get_option_value "$separator_left_config" "$separator_left_default")" \
    section_b="#[fg=$(get_mode_color),bg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default")]$(get_option_value "$section_b_config" "$section_b_default")" \
    separator_bc="#[fg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default"),bg=default]$(get_option_value "$separator_left_config" "$separator_left_default")" \
    section_c="#[fg=default,bg=default]$(get_option_value "$section_c_config" "$section_c_default")" \
    section_x="#[fg=default,bg=default]$(get_option_value "$section_x_config" "$section_x_default")" \
    separator_xy="#[fg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default"),bg=default]$(get_option_value "$separator_right_config" "$separator_right_default")" \
    section_y="#[fg=$(get_mode_color),bg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default")]$(get_option_value "$section_y_config" "$section_y_default")" \
    separator_yz="#[fg=$(get_mode_color),bg=$(get_option_value "$section_by_bg_config" "$section_by_bg_default")]$(get_option_value "$separator_right_config" "$separator_right_default")" \
    section_z="#[fg=black,bg=$(get_mode_color)]$(get_option_value "$section_z_config" "$section_z_default")"

  local -r \
    status_left="$section_a$separator_ab$section_b$separator_bc$section_c" \
    status_right="$section_x$separator_xy$section_y$separator_yz$section_z"

  local -r \
    normal_mode_indicator="$(get_option_value "$normal_mode_indicator_config" "$normal_mode_indicator_default")" \
    prefix_mode_indicator="$(get_option_value "$prefix_mode_indicator_config" "$prefix_mode_indicator_default")" \
    copy_mode_indicator="$(get_option_value "$copy_mode_indicator_config" "$copy_mode_indicator_default")" \
    sync_mode_indicator="$(get_option_value "$sync_mode_indicator_config" "$sync_mode_indicator_default")" \
    nested_mode_indicator="$(get_option_value "$nested_mode_indicator_config" "$nested_mode_indicator_default")"

  local -r mode_indicator="#{?#{==:#{client_key_table},off},$nested_mode_indicator,#{?synchronize-panes,$sync_mode_indicator,#{?client_prefix,$prefix_mode_indicator,#{?pane_in_mode,$copy_mode_indicator,$normal_mode_indicator}}}}"

  tmux set-option -gq status-left "${status_left/$mode_indicator_placeholder/$mode_indicator}"
  tmux set-option -gq status-right "${status_right/$mode_indicator_placeholder/$mode_indicator}"
  tmux set-option -gq mode-style "fg=$(get_option_value "$copy_mode_color_config" "$copy_mode_color_default"),bg=brightblack"
}

main
