#Author zsnmwy
#https://github.com/zsnmwy/max-translation-update-script
#获取稳定版 V1
Write-Output "   "  "请不要在脚本运行目录 存放  max.zip 以及 strings.po" " " " " "会被删掉的"
Pause

function judge {
    param(
        [string]$Name = $(throw "Parameter missing: -name Name")
    )
    if ($?) {
        Write-Output "成功 $Name"
        Write-Output "              "
    }
    else {
        Write-Output "失败 $Name"
        Write-Output "    " "搞不定就来github提issue" "https://github.com/zsnmwy/max-translation-update-script"
        Pause
        exit
    }
}

$api_url = "http://steamworkshopdownloader.com/api/workshop/935864920"
$file_path = "$pwd"
$wegame_path = "$pwd\OxygenNotIncluded_rail_Data\StreamingAssets\Mods"
$steam_path = "$pwd\OxygenNotIncluded_Data\StreamingAssets\Mods"

$ErrorActionPreference = "SilentlyContinue"
$judge_wegame_path = Test-Path "$wegame_path"
$judge_steam_path = Test-Path "$steam_path"
$judge_file_max = Test-Path "$file_path\max.zip"
$judge_file_po = Test-Path "$file_path\strings.po"
$ErrorActionPreference = "Continue"

if ( "$judge_wegame_path" -eq "True" ) {
    $now_path = $wegame_path
    Write-Output "wegame $now_path"
    Write-Output "  " "当前目录为WeGame版本的缺氧" "   " "如果识别错误，请关闭当前的脚本" "   " "按回车继续" "   "
    Pause
}
elseif ( "$judge_steam_path" -eq "True" ) {
    $now_path = $steam_path
    Write-Output "steam $now_path"
    Write-Output "  " "当前目录为Steam版本的缺氧" "   " "如果识别错误，请关闭当前的脚本" "   " "按回车继续" "   "
    Pause
}
else {
    Write-Output "    " "请把脚本放到缺氧的游戏根目录"
    Write-Output "   "  "Steam版本的  应该把脚本放在 \...\OxygenNotIncluded\"  
    Write-Output "   " "WeGame版本的  应该把脚本放在 \...\WeGame\rail_apps\缺氧(2000075)\"
    Pause
    exit
}

if ("$judge_file_max" -eq "True") {
    Remove-Item "$file_path\max.zip"
    judge -Name "删除max.zip"
}
if ("$judge_file_po" -eq "True") {
    Remove-Item "$file_path\strings.po"
    judge -Name "删除strings.po"
}

$data = Invoke-WebRequest $api_url
judge -Name "请求Workshop API"
$decode = ConvertFrom-Json $data.content

$file_url = $decode.file_url
judge -Name "解析file—url"

Write-Output "file-url 为 $file_url"

Invoke-WebRequest $file_url -OutFile "$file_path\max.zip"

judge -Name "下载最新max汉化"

Write-Output $file_path

Expand-Archive -Path "$file_path\max.zip" -DestinationPath $file_path

judge -Name "解压max.zip到当前目录"

$test_max = Test-Path "$file_path\strings.po"

if ("$test_max" -eq "False") {
    Write-Output "找不到strings.po"
    Write-Output "不进行替换"
    Pause
    exit
}
$ErrorActionPreference = "SilentlyContinue"
$test_strings_po = Test-Path "$now_path\strings.po"
$ErrorActionPreference = "Continue"
if ("$test_strings_po" -eq "True") {
    $date = Get-Date -Format MMddHHmm
    Write-Output "检测到原翻译目录存在 srtings.po"
    Move-Item -Path "$now_path\strings.po" -Destination "$file_path\strings.po(此为原目录的翻译，去掉括号内的内容以及两边的括号即可用 时间戳 $date)"
    judge -Name "备份原strings.po 到脚本目录"
    Move-Item -Path "$file_path\strings.po" -Destination "$now_path\strings.po"
    judge -Name "移动strings.po 到翻译目录中"
}
else {
    Write-Output "没有发现strings.po  直接移动strings.po"
    Move-Item -Path "$file_path\strings.po" -Destination "$now_path\strings.po"
    judge -Name "移动strings.po 到翻译目录中"
}

Write-Output "更新max翻译完成" "    "
Write-Output "请进入游戏直接就是max翻译" "    "
Write-Output "有问题？来GitHub 反馈  " "   "  "https://github.com/zsnmwy/max-translation-update-script"
Remove-Item "$file_path\max.zip"
Pause
