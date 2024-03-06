#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

if [ ! -x /opt/cargo/bin/cargo ]; then
    echo "export CARGO_HOME='/opt/cargo'" >>/etc/profile.d/rust.sh
	echo "export RUSTUP_HOME='/opt/rustup'" >>/etc/profile.d/rust.sh
	echo 'export PATH="$CARGO_HOME/bin:$PATH"' >>/etc/profile.d/rust.sh
	source /etc/profile.d/rust.sh
	echo 'curl https://sh.rustup.rs -sSf | sh -s -- -y;' | su root
	source $CARGO_HOME/env
	export PATH=$CARGO_HOME/env:$PATH
fi

# install some forensic tools
cargo install dfir-toolkit ntdsextract2 xsv ripgrep stringsext mft2bodyfile mft2bodyfile usnjrnl regview ntdsextract2 bat broot
cargo install --features="feature_capable" qsv

# generate autocompletes
mkdir -p /usr/local/share/zsh/site-functions
cleanhive --autocomplete bash >/etc/bash_completion.d/dfir-dd_cleanhive
cleanhive --autocomplete zsh >/usr/local/share/zsh/site-functions/_cleanhive
es4forensics --autocomplete bash >/etc/bash_completion.d/dfir-dd_es4forensics
es4forensics --autocomplete zsh >/usr/local/share/zsh/site-functions/_es4forensics
evtx2bodyfile --autocomplete bash >/etc/bash_completion.d/dfir-dd_evtx2bodyfile
evtx2bodyfile --autocomplete zsh >/usr/local/share/zsh/site-functions/_evtx2bodyfile
evtxanalyze --autocomplete bash >/etc/bash_completion.d/dfir-dd_evtxanalyze
evtxanalyze --autocomplete zsh >/usr/local/share/zsh/site-functions/_evtxanalyze
evtxcat --autocomplete bash >/etc/bash_completion.d/dfir-dd_evtxcat
evtxcat --autocomplete zsh >/usr/local/share/zsh/site-functions/_evtxcat
evtxls --autocomplete bash >/etc/bash_completion.d/dfir-dd_evtxls
evtxls --autocomplete zsh >/usr/local/share/zsh/site-functions/_evtxls
evtxscan --autocomplete bash >/etc/bash_completion.d/dfir-dd_evtxscan
evtxscan --autocomplete zsh >/usr/local/share/zsh/site-functions/_evtxscan
hivescan --autocomplete bash >/etc/bash_completion.d/dfir-dd_hivescan
hivescan --autocomplete zsh >/usr/local/share/zsh/site-functions/_hivescan
ipgrep --autocomplete bash >/etc/bash_completion.d/dfir-dd_ipgrep
ipgrep --autocomplete zsh >/usr/local/share/zsh/site-functions/_ipgrep
lnk2bodyfile --autocomplete bash >/etc/bash_completion.d/dfir-dd_lnk2bodyfile
lnk2bodyfile --autocomplete zsh >/usr/local/share/zsh/site-functions/_lnk2bodyfile
mactime2 --autocomplete bash >/etc/bash_completion.d/dfir-dd_mactime2
mactime2 --autocomplete zsh >/usr/local/share/zsh/site-functions/_mactime2
pol_export --autocomplete bash >/etc/bash_completion.d/dfir-dd_pol_export
pol_export --autocomplete zsh >/usr/local/share/zsh/site-functions/_pol_export
regdump --autocomplete bash >/etc/bash_completion.d/dfir-dd_regdump
regdump --autocomplete zsh >/usr/local/share/zsh/site-functions/_regdump
ts2date --autocomplete bash >/etc/bash_completion.d/dfir-dd_ts2date
ts2date --autocomplete zsh >/usr/local/share/zsh/site-functions/_ts2date