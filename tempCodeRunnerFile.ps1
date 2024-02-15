
$response = Invoke-WebRequest -Uri 'https://github.com/judigot/references/blob/main/Apportable.sh'

$html = $response.ParsedHtml
$elementValue = $html.getElementById('read-only-cursor-text-area').innerHTML

echo $html