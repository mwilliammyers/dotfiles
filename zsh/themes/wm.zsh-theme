# My customized version of the Soliah theme from oh-my-zsh

PROMPT='%{$FG[061]%}%n%{$reset_color%}@%{$FG[064]%}%M%{$reset_color%}: %{$FG[033]%}%~%b%{$reset_color%} $(git_time_since_commit)$(check_git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$FG[245]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

# Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}" 

# Text to display if the branch is clean
ZSH_THEME_GIT_PROMPT_CLEAN="" 

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$FG[241]%}"

#ZSH_THEME_GIT_PROMPT_PREFIX=": "
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%} :"
#ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
#ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

#ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[103]%}✚%{$rset_color%}"
#ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[103]%}✹%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[103]%}✖%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[103]%}➜%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[103]%}═%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[103]%}✭%{$reset_color%}"

# Git sometimes goes into a detached head state. git_prompt_info doesn't
# return anything in this case. So wrap it in another function and check
# for an empty string.
function check_git_prompt_info() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "%{$fg[magenta]%}detached-head%{$reset_color%})"
        else
            echo "$(git_prompt_info)"
        fi
    fi
}

# Determine if we are using a gemset.
function rvm_gemset() {
    if hash rvm 2>/dev/null; then
        GEMSET=`rvm gemset list | grep '=>' | cut -b4-`
        if [[ -n $GEMSET ]]; then
            echo "%{$fg[yellow]%}$GEMSET%{$reset_color%}|"
        fi 
    fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))
           
            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))
            
            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "($(rvm_gemset)$COLOR${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            elif [ "$MINUTES" -gt 60 ]; then
                echo "($(rvm_gemset)$COLOR${HOURS}h${SUB_MINUTES}m%{$reset_color%}|"
            else
                echo "($(rvm_gemset)$COLOR${MINUTES}m%{$reset_color%}|"
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "($(rvm_gemset)$COLOR~|"
        fi
    fi
}

function solarize(){
print -P -- "\n###############################################################################"
print -P -- "SOLARIZED  HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      RGB         HSB"
print -P -- "--------   ------- ---- -------  ----------- ---------- ----------- -----------"
print -P -- "#%F{234}base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21%f"
print -P -- "#%F{235}base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26%f"
print -P -- "#%F{240}base01    #586e75 10/7 brgreen  240 #585858 45 -07 -07  88 110 117 194  25  46%f"
print -P -- "#%F{241}base00    #657b83 11/7 bryellow 241 #626262 50 -07 -07 101 123 131 195  23  51%f"
print -P -- "#%F{244}base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59%f"
print -P -- "#%F{245}base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63%f"
print -P -- "#%F{254}base2     #eee8d5  7/7 white    254 #e4e4e4 92 -00  10 238 232 213  44  11  93%f"
print -P -- "#%F{230}base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99%f"
print -P -- "#%F{136}yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71%f"
print -P -- "#%F{166}orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80%f"
print -P -- "#%F{160}red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86%f"
print -P -- "#%F{125}magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83%f"
print -P -- "#%F{061}violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77%f"
print -P -- "#%F{033}blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82%f"
print -P -- "#%F{037}cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63%f"
print -P -- "#%F{064}green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60%f"
print -P -- "###############################################################################\n"
}
