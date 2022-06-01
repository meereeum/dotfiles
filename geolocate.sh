#!/bin/bash

MY_IP=$( dig -4 +short myip.opendns.com @resolver1.opendns.com )

# curl -s https://ipvigilante.com/$MY_IP |
#   jq -c '.data | [.latitude, .longitude]' |

# curl -s https://freegeoip.app/json/$MY_IP |
#    jq -c '[.latitude, .longitude]' |

curl -s http://ip-api.com/json/$MY_IP |
    jq -c '[.lat, .lon]' |
    tr -d '[]"' > /tmp/latlon
