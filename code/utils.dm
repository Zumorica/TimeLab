/proc/ReplaceText(var/string, var/sub, var/replacement)
	var/sub_len = length(sub)
	var/replacement_len = length(replacement)
	var/pos = findtext(string, sub)
	while(pos)
		string = copytext(string, 1, pos) + replacement + copytext(string, pos+sub_len)
		pos = findtext(string, sub, pos+replacement_len)
	return string

/proc/TextSplit(var/string, var/delimeter=" ")
	var/start_pos = 1
	var/pos = findtext(string, delimeter)
	var/length = length(delimeter)

	var/list/words = list()

	while(pos > 0)
		words += copytext(string, start_pos, pos)
		start_pos = pos + length
		pos = findtext(string, delimeter, start_pos)

	words += copytext(string, start_pos)
	return words
