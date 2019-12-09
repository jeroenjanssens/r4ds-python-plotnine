/\[\^\]/ {
    split($0, parts, /\[\^\]\(|\.\)/)
    for (p = 1; p < length(parts); p++) {
        if (p % 2) {
            printf "%s[^%d]", parts[p], ++i
        } else {
            notes[i] = parts[p]
        }
    }
    print parts[p]
    next
}

{
    print
}

END {
    print "\n## Footnotes\n"

    for (i = 1; i <= length(notes); i++) {
        print "[^" i "]: " notes[i] "."
    }
}
