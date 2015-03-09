#!/bin/bash
set -e

declare -A aliases
aliases=(
	[0.12.0]='0 latest'
)

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

repos=( "$@" )
if [ ${#repos[@]} -eq 0 ]; then
	repos=( */ )
fi
repos=( "${repos[@]%/}" )

echo '# maintainer: Joyent Image Team <image-team@joyent.com> (@joyent)'
echo '# maintainer: Trong Nghia Nguyen - resin.io <james@resin.io>'

for repo in "${repos[@]}"; do

	cd $repo
	versions=( */ )
	versions=( "${versions[@]%/}" )
	
	url='git://github.com/nghiant2710/docker-node'
	for version in "${versions[@]}"; do
		cd $version
		fullVersions=( */ )
		fullVersions=( "${fullVersions[@]%/}" )
		cd ..
		for fullVersion in "${fullVersions[@]}"; do

			commit="$(git log -1 --format='format:%H' -- "$version/$fullVersion")"
			#fullVersion="$(grep -m1 'ENV NODE_VERSION ' "$repo/$version/Dockerfile" | cut -d' ' -f3)"
			versionAliases=( $fullVersion ${aliases[$fullVersion]} )

			echo
			for va in "${versionAliases[@]}"; do
				echo "$va: ${url}@${commit} $repo/$version/$fullVersion"
			done
		
			for variant in onbuild slim wheezy; do
				commit="$(git log -1 --format='format:%H' -- "$version/$fullVersion/$variant")"
				echo
				for va in "${versionAliases[@]}"; do
					if [ "$va" = 'latest' ]; then
						va="$variant"
					else
						va="$va-$variant"
					fi
					echo "$va: ${url}@${commit} $repo/$version/$fullVersion/$variant"
				done
			done

			# Only for armv7hf
			if [ $repo == 'armv7hf' ]; then
				variant='sid'
				commit="$(git log -1 --format='format:%H' -- "$version/$fullVersion/$variant")"
				echo
				for va in "${versionAliases[@]}"; do
					if [ "$va" = 'latest' ]; then
						va="$variant"
					else
						va="$va-$variant"
					fi
					echo "$va: ${url}@${commit} $repo/$version/$fullVersion/$variant"
				done
			fi			
		done
	done
	cd ..
done
