#!/usr/bin/env bash

wpctl get-volume @DEFAULT_SOURCE@ | grep -qi muted && echo mute || echo record
