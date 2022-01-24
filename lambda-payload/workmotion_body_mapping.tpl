{
    "body" : $input.json('$'),
    "headers": {
      #foreach($header in $input.params().header.keySet())
      "$header": "$util.escapeJavaScript($input.params().header.get($header))" #if($foreach.hasNext),#end
  
      #end
    },
    "method": "$context.httpMethod"
  }