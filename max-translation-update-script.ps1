#Author zsnmwy
#https://github.com/zsnmwy/max-translation-update-script

Write-Output "   "  "请不要在脚本运行目录 存放  max.zip 以及 strings.po" " " " " "会被删掉的"
Pause

function judge {
    param(
        [string]$Name = $(throw "Parameter missing: -name Name")
    )
    if ($?) {
        Write-Output "$Name 成功"
        Write-Output "         "
    }
    else {
        Write-Output "$Name 失败"
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

$date = Get-Date -Format MMddHHmm

Move-Item -Path "$now_path\strings_preinstalled_zh_klei.po" -Destination "$file_path\strings_preinstalled_zh_klei.po(此为原目录的翻译，去掉括号内的内容以及两边的括号即可用 $date)"

judge -Name "移动原翻译目录的翻译文件到当前游戏根目录 并 重命令为 strings_preinstalled_zh_klei.po(此为原目录的翻译，去掉括号内的内容以及两边的括号即可用 $date)"

Move-Item -Path "$file_path\strings.po" -Destination "$now_path\strings_preinstalled_zh_klei.po"

judge -Name "移动max翻译到翻译目录 并  更改strings.po的名字为 strings_preinstalled_zh_klei.po"


Write-Output "更新max翻译完成"
Write-Output "请进入游戏选择官中 (wg没得选，直接就是max翻译)"
Write-Output "实质是把官中的文件给替换掉了  相当于 重命名 -- 替换"
Remove-Item "$file_path\max.zip"
Pause
