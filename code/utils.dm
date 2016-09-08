/proc/ReplaceText(var/string, var/sub, var/replacement)
	var/sub_len = length(sub)
	var/replacement_len = length(replacement)
	var/pos = findtext(string, sub)
	while(pos)
		string = copytext(string, 1, pos) + replacement + copytext(string, pos+sub_len)
		pos = findtext(string, sub, pos+replacement_len)
	return string
