MONITOR=DP-3
WALLPAPER=~/Pictures/wallpapers/sebastian-svenson-unsplash.jpg
OUT=/tmp/wallpaper-${MONITOR}.jpg

RES=$(
  xrandr --query |
    awk -v m="$MONITOR" '
      $1 == m && $2 == "connected" {
        for (i = 3; i <= NF; i++) {
          if ($i ~ /^[0-9]+x[0-9]+\+[0-9]+\+[0-9]+$/) {
            split($i, a, "+")
            print a[1]
            exit
          }
        }
      }
    '
)

if [ -z "$RES" ]; then
  echo "Could not detect resolution for monitor: $MONITOR" >&2
  exit 1
fi

magick "$WALLPAPER" -resize "${RES}^" -gravity center -extent "$RES" "$OUT"
feh --bg-fill "$OUT"
