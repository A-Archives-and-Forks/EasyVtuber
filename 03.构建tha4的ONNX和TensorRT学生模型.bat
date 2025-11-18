@echo off
setlocal enabledelayedexpansion
cd /D "%~dp0"

SET PATH=%~dp0envs\python_embedded;%~dp0envs\python_embedded\Scripts;%~dp0envs\python_embedded\Library\bin;%PATH%

echo ================================================================================
echo THA4 学生模型 ONNX 和 TensorRT 转换工具
echo ================================================================================
echo.

REM 检查模型目录是否存在
if not exist "data\models\custom_tha4_models" (
    echo [错误] 找不到模型目录: data\models\custom_tha4_models
    pause
    exit /b 1
)

echo 可用的 THA4 学生模型:
echo --------------------------------------------------------------------------------
set count=0
for /d %%i in (data\models\custom_tha4_models\*) do (
    set /a count+=1
    echo [!count!] %%~nxi
)
echo --------------------------------------------------------------------------------
echo.

if %count%==0 (
    echo [错误] 未找到任何模型文件夹
    pause
    exit /b 1
)

echo 请输入要转换的模型文件夹名称:
set /p MODEL_NAME=^> 

REM 检查输入是否为空
if "%MODEL_NAME%"=="" (
    echo [错误] 模型名称不能为空
    pause
    exit /b 1
)

REM 检查模型文件夹是否存在
if not exist "data\models\custom_tha4_models\%MODEL_NAME%" (
    echo [错误] 模型文件夹不存在: data\models\custom_tha4_models\%MODEL_NAME%
    pause
    exit /b 1
)

echo.
echo ================================================================================
echo 步骤 1/2: 导出 ONNX 模型
echo ================================================================================
echo 模型: %MODEL_NAME%
echo 命令: python onnx_export_tha4_student.py %MODEL_NAME% --cpu
echo --------------------------------------------------------------------------------
echo.

python onnx_export_tha4_student.py %MODEL_NAME% --cpu

echo ================================================================================
echo 步骤 2/2: 转换为 TensorRT 模型
echo ================================================================================
echo 模型: %MODEL_NAME%
echo 命令: python tha4_student_convert_onnx_to_trt.py %MODEL_NAME% fp32
echo --------------------------------------------------------------------------------
echo.

python tha4_student_convert_onnx_to_trt.py %MODEL_NAME% fp32

pause

