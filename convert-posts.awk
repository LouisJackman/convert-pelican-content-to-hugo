#
# Convert Pelican articles to Hugo.
#

BEGIN {
    is_parsing_header = 1
    inside_language_block = 0
    prev_code_line = ""

    print "+++"
}

{
    is_first_line = (NR == 1)
    is_blank = ($0 ~ /^[ \t]*$/)
    no_longer_language_block = ((0 < length($0)) && ($0 !~ /^[ \t]/))
    is_tags = /^ *[tT]ags[^:]*:/
    is_date = /^ *[dD]ate[^:]*:/
    is_summary = /^ *[sS]ummary[^:]*:/
    is_language_header = /^[ \t]*:::/
}

is_parsing_header && is_blank {
    is_parsing_header = 0
    print "+++"
    print
    next
}

is_parsing_header {
    header_name = $0
    header_value = $0

    sub(/:.*$/, "", header_name)
    sub(/^[^:]*: /, "", header_value)
    gsub(/"/, "\\\"", header_value)

    $0 = sprintf( \
        "%s = \"%s\"", \
        tolower(header_name), \
        header_value \
    )

    sub(/^summary/, "description")
}

is_parsing_header && is_date {
    sub(/  *[^"][^"]*" *$/, "\"")
}

is_parsing_header && is_tags {
    sub(/= "/, "= [\"")
    gsub( \
         /, */, \
         "\", \"" \
    )
    sub(/$/, "]")
    print
    next
}

is_parsing_header && is_summary {
    next
}

is_language_header {
    inside_language_block = 1
    sub(/[ \t]*:::/, "```")
    sub(/text *$/, "")
    prev_code_line = $0
    getline
    if ($0 ~ /^[ \t]*$/) {
        next
    }
}

inside_language_block && no_longer_language_block {
    inside_language_block = 0

    if (prev_code_line !~ /^ *$/) {
        print prev_code_line
    }

    print "```"
    print ""
    print
    next
}

inside_language_block {
    if ($0 ~ /^\t/) {
        sub(/^\t/, "")
    } else {
        sub(/^    /, "")
    }
    gsub(/\t/, "    ")
    print prev_code_line
    prev_code_line = $0
    next
}

1

