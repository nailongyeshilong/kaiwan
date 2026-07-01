$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$root = Split-Path -Parent $PSScriptRoot
$refPath = (Get-ChildItem (Join-Path $root 'docs\pics\*.png') | Select-Object -First 1 -ExpandProperty FullName)
$outPath = Join-Path $root 'docs\pics\home-extract-result-ui-design.png'

$width = 1290
$height = 2796

function New-Color($hex, $alpha = 255) {
  $hex = $hex.TrimStart('#')
  $r = [Convert]::ToInt32($hex.Substring(0, 2), 16)
  $g = [Convert]::ToInt32($hex.Substring(2, 2), 16)
  $b = [Convert]::ToInt32($hex.Substring(4, 2), 16)
  return [System.Drawing.Color]::FromArgb($alpha, $r, $g, $b)
}

function U([int[]]$codes) {
  return -join ($codes | ForEach-Object { [char]$_ })
}

function New-RoundRect([float]$x, [float]$y, [float]$w, [float]$h, [float]$r) {
  $path = New-Object System.Drawing.Drawing2D.GraphicsPath
  $d = $r * 2
  $path.AddArc($x, $y, $d, $d, 180, 90)
  $path.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
  $path.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
  $path.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
  $path.CloseFigure()
  return $path
}

function Draw-CenteredText($g, $text, $font, $brush, [System.Drawing.RectangleF]$rect) {
  $format = New-Object System.Drawing.StringFormat
  $format.Alignment = [System.Drawing.StringAlignment]::Center
  $format.LineAlignment = [System.Drawing.StringAlignment]::Center
  $g.DrawString($text, $font, $brush, $rect, $format)
  $format.Dispose()
}

$bmp = New-Object System.Drawing.Bitmap($width, $height)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear((New-Color '#08111B'))

$ref = [System.Drawing.Image]::FromFile($refPath)
$g.DrawImage($ref, 0, 0, $width, $height)

$bgBrush = New-Object System.Drawing.SolidBrush((New-Color '#07111B' 175))
$g.FillRectangle($bgBrush, 0, 0, $width, $height)

for ($i = 0; $i -lt 12; $i++) {
  $pen = New-Object System.Drawing.Pen((New-Color '#19314B' (20 + $i * 4)), 2)
  $g.DrawLine($pen, 0, $i * 240, $width, [int]($i * 240 + 160))
  $pen.Dispose()
}

for ($i = 0; $i -lt 10; $i++) {
  $pen = New-Object System.Drawing.Pen((New-Color '#13273D' 26), 2)
  $g.DrawLine($pen, $i * 180, 0, [int]($i * 180 + 260), $height)
  $pen.Dispose()
}

$titleFont = New-Object System.Drawing.Font('Microsoft YaHei', 44, [System.Drawing.FontStyle]::Bold)
$subFont = New-Object System.Drawing.Font('Microsoft YaHei', 18, [System.Drawing.FontStyle]::Regular)
$g.DrawString((U @(24320,29609)), $titleFont, ([System.Drawing.Brushes]::White), 500, 100)
$g.DrawString((U @(20170,26085,25277,21462,32467,26524,24050,29983,25104)), $subFont, (New-Object System.Drawing.SolidBrush((New-Color '#9AAABD'))), 455, 190)

$badgePath = New-RoundRect 390 270 510 86 18
$badgeBrush = New-Object System.Drawing.SolidBrush((New-Color '#173252' 230))
$badgePen = New-Object System.Drawing.Pen((New-Color '#4A88C8'), 3)
$g.FillPath($badgeBrush, $badgePath)
$g.DrawPath($badgePen, $badgePath)
Draw-CenteredText $g ((U @(31532)) + ' 2 ' + (U @(27425,25277,21462)) + '  ·  ' + (U @(36824,21487,37325,25277)) + ' 1 ' + (U @(27425))) (New-Object System.Drawing.Font('Microsoft YaHei', 18, [System.Drawing.FontStyle]::Bold)) (New-Object System.Drawing.SolidBrush((New-Color '#9ED4FF'))) ([System.Drawing.RectangleF]::new(390, 270, 510, 86))

$cardPath = New-RoundRect 110 410 1070 1300 34
$cardBrush = New-Object System.Drawing.SolidBrush((New-Color '#0D1724' 235))
$cardPen = New-Object System.Drawing.Pen((New-Color '#3D84C7'), 3)
$g.FillPath($cardBrush, $cardPath)
$g.DrawPath($cardPen, $cardPath)

$srcRect = [System.Drawing.Rectangle]::new(170, 350, 690, 1030)
$destRect = [System.Drawing.Rectangle]::new(155, 480, 980, 980)
$g.DrawImage($ref, $destRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)

$shadowBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  ([System.Drawing.Rectangle]::new(155, 950, 980, 510)),
  (New-Color '#02060C' 0),
  (New-Color '#02060C' 235),
  90
)
$g.FillRectangle($shadowBrush, 155, 950, 980, 510)

$gameTitleFont = New-Object System.Drawing.Font('Microsoft YaHei', 54, [System.Drawing.FontStyle]::Bold)
$gameSubFont = New-Object System.Drawing.Font('Microsoft YaHei', 18, [System.Drawing.FontStyle]::Regular)
Draw-CenteredText $g (U @(26143,31353,26029,30028)) $gameTitleFont (New-Object System.Drawing.SolidBrush((New-Color '#EEF5FF'))) ([System.Drawing.RectangleF]::new(190, 1300, 900, 110))
Draw-CenteredText $g ((U @(32426,20803,37325,21551)) + ' · ' + (U @(21629,36816,30001,20320,20070,20889))) $gameSubFont (New-Object System.Drawing.SolidBrush((New-Color '#A6B7CB'))) ([System.Drawing.RectangleF]::new(200, 1410, 880, 50))

$tagFont = New-Object System.Drawing.Font('Microsoft YaHei', 15, [System.Drawing.FontStyle]::Bold)
$tags = @(
  @{ X = 285; W = 150; Text = (U @(31185,24187,21490,35799)); Bg = '#17304E'; Fg = '#7CC0FF' },
  @{ X = 460; W = 130; Text = (U @(39640,27889,28024)); Bg = '#142B3F'; Fg = '#A0BDD8' },
  @{ X = 615; W = 170; Text = (U @(21333,20154,20882,38505)); Bg = '#142B3F'; Fg = '#A0BDD8' }
)
foreach ($tag in $tags) {
  $path = New-RoundRect $tag.X 1535 $tag.W 54 16
  $g.FillPath((New-Object System.Drawing.SolidBrush((New-Color $tag.Bg 220))), $path)
  $g.DrawPath((New-Object System.Drawing.Pen((New-Color '#31597D'), 2)), $path)
  Draw-CenteredText $g $tag.Text $tagFont (New-Object System.Drawing.SolidBrush((New-Color $tag.Fg))) ([System.Drawing.RectangleF]::new($tag.X, 1535, $tag.W, 54))
}

$labelFont = New-Object System.Drawing.Font('Microsoft YaHei', 18, [System.Drawing.FontStyle]::Regular)
$valueFont = New-Object System.Drawing.Font('Microsoft YaHei', 34, [System.Drawing.FontStyle]::Bold)
$cards = @(
  @{ X = 80; Title = (U @(21097,20313,25277,21462)); Value = '1/3'; Color = '#55B6FF' },
  @{ X = 470; Title = (U @(20170,26085,29366,24577)); Value = (U @(26410,38145,23450)); Color = '#72C8FF' },
  @{ X = 860; Title = (U @(38145,23450,35268,21017)); Value = ('3' + (U @(27425,21518,38145,23450))); Color = '#DDEBFA' }
)
foreach ($item in $cards) {
  $path = New-RoundRect $item.X 1760 350 196 24
  $g.FillPath((New-Object System.Drawing.SolidBrush((New-Color '#101A28' 235))), $path)
  $g.DrawPath((New-Object System.Drawing.Pen((New-Color '#244D76'), 2)), $path)
  $g.DrawString($item.Title, $labelFont, (New-Object System.Drawing.SolidBrush((New-Color '#93A4B7'))), $item.X + 34, 1802)
  $g.DrawString($item.Value, $valueFont, (New-Object System.Drawing.SolidBrush((New-Color $item.Color))), $item.X + 34, 1856)
}

$hintPath = New-RoundRect 80 1990 1130 165 24
$g.FillPath((New-Object System.Drawing.SolidBrush((New-Color '#0F1824' 228))), $hintPath)
$g.DrawPath((New-Object System.Drawing.Pen((New-Color '#1A3553'), 2)), $hintPath)
$infoPen = New-Object System.Drawing.Pen((New-Color '#4B9FFF'), 4)
$g.DrawEllipse($infoPen, 120, 2038, 60, 60)
$g.DrawString('i', (New-Object System.Drawing.Font('Microsoft YaHei', 24, [System.Drawing.FontStyle]::Bold)), (New-Object System.Drawing.SolidBrush((New-Color '#4B9FFF'))), 143, 2037)
$g.DrawString((U @(29616,22312,21487,20197,32487,32493,37325,25277,65292,20063,21487,20197,30452,25509,25509,21463,36825,20010,32467,26524,12290)), (New-Object System.Drawing.Font('Microsoft YaHei', 17, [System.Drawing.FontStyle]::Regular)), (New-Object System.Drawing.SolidBrush((New-Color '#BCC8D6'))), 210, 2038)
$g.DrawString(((U @(31532)) + ' 3 ' + (U @(27425,25277,21462,23436,25104,21518,65292,20170,26085,32467,26524,23558,33258,21160,38145,23450,24182,20889,20837,35760,24405,12290))), (New-Object System.Drawing.Font('Microsoft YaHei', 15, [System.Drawing.FontStyle]::Regular)), (New-Object System.Drawing.SolidBrush((New-Color '#7E91A8'))), 210, 2086)

$leftPath = New-RoundRect 80 2205 475 160 24
$g.FillPath((New-Object System.Drawing.SolidBrush((New-Color '#142131' 236))), $leftPath)
$g.DrawPath((New-Object System.Drawing.Pen((New-Color '#34597B'), 3)), $leftPath)
Draw-CenteredText $g (U @(20877,25277,19968,27425)) (New-Object System.Drawing.Font('Microsoft YaHei', 28, [System.Drawing.FontStyle]::Bold)) (New-Object System.Drawing.SolidBrush((New-Color '#DCEBFF'))) ([System.Drawing.RectangleF]::new(80, 2205, 475, 160))

$rightPath = New-RoundRect 635 2205 575 160 24
$rightBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  ([System.Drawing.Rectangle]::new(635, 2205, 575, 160)),
  (New-Color '#2A85EB'),
  (New-Color '#58B0FF'),
  0
)
$g.FillPath($rightBrush, $rightPath)
$g.DrawPath((New-Object System.Drawing.Pen((New-Color '#A8DDFF'), 3)), $rightPath)
Draw-CenteredText $g (U @(23601,29609,36825,20010)) (New-Object System.Drawing.Font('Microsoft YaHei', 28, [System.Drawing.FontStyle]::Bold)) (New-Object System.Drawing.SolidBrush((New-Color '#F7FBFF'))) ([System.Drawing.RectangleF]::new(635, 2205, 575, 160))

$navBrush = New-Object System.Drawing.SolidBrush((New-Color '#0C1520' 235))
$g.FillRectangle($navBrush, 0, 2520, $width, 276)
$navFont = New-Object System.Drawing.Font('Microsoft YaHei', 16, [System.Drawing.FontStyle]::Bold)
$navItems = @(
  @{ X = 165; Text = (U @(39318,39029)); Color = '#4AA5FF' },
  @{ X = 430; Text = (U @(28216,25103,24211)); Color = '#7F8B9B' },
  @{ X = 760; Text = (U @(35760,24405)); Color = '#7F8B9B' },
  @{ X = 1070; Text = (U @(35774,32622)); Color = '#7F8B9B' }
)
foreach ($nav in $navItems) {
  $pen = New-Object System.Drawing.Pen((New-Color $nav.Color), 3)
  $g.DrawEllipse($pen, $nav.X - 24, 2588, 48, 48)
  Draw-CenteredText $g $nav.Text $navFont (New-Object System.Drawing.SolidBrush((New-Color $nav.Color))) ([System.Drawing.RectangleF]::new($nav.X - 45, 2648, 90, 40))
}

$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)

$ref.Dispose()
$g.Dispose()
$bmp.Dispose()

Write-Output $outPath
