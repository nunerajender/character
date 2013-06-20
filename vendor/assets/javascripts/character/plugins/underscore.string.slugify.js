var ___defaultToWhiteSpace = function(characters) {
  if (characters == null)
    return '\\s';
  else if (characters.source)
    return characters.source;
  else
    return '[' + _.string.escapeRegExp(characters) + ']';
};

_.string.slugify = function(str) {
  if (str == null) return '';

  var from  = "ąàáäâãåæćęèéëêìíïîłńòóöôõøùúüûñçżź",
      to    = "aaaaaaaaceeeeeiiiilnoooooouuuunczz",
      regex = new RegExp(___defaultToWhiteSpace(from), 'g');

  str = String(str).toLowerCase().replace(regex, function(c){
    var index = from.indexOf(c);
    return to.charAt(index) || '-';
  });

  return _.string.dasherize(str.replace(/[^\w\sабвгдеёжзийклмнопрстуфхцчшщъыьэюя-]/g, ''));
};