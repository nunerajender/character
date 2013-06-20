
String.prototype.replace_nth_occurrence = function (strTextToReplace, strReplaceWith, replaceAt) {
    var strData = this
    var index = strData.indexOf(strTextToReplace);
    for (var i = 1; i < replaceAt; i++)
        index = strData.indexOf(strTextToReplace, index + 1);
    if (index >= 0)
        return strData.substr(0, index) + strReplaceWith + strData.substr(index + strTextToReplace.length, strData.length);
    return strData;
};