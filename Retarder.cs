using System;
using System.IO;
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

//Previous Versions Generate .Net Framework Project Files. So Retarder isn't needed for those.
#if UNITY_EDITOR && UNITY_2021_1_OR_NEWER
namespace Retarder
{
    public static class Retarder
    {
        [MenuItem("Retarder/Retard C# Project")]
        private static void RetardRetard() => RetardProjectFiles();
        [MenuItem("Assets/Retard C# Project")]
        private static void AssetsRetard() => RetardProjectFiles();

        /*
        [MenuItem("Retarder/Update Retarded C# Project")]
        private static void RetardUpdate() => UpdateProjectFiles();
        [MenuItem("Assets/Update Retarded C# Project")]
        private static void AssetsUpdate() => UpdateProjectFiles();
        */

        /*
        [MenuItem("Retarder/Open Retarded C# Project")]
        private static void RetardOpen() => OpenProjectFiles();
        [MenuItem("Assets/Open Retarded C# Project")]
        private static void AssetsOpen() => OpenProjectFiles();
        */

        //TODO: Take the Generated Project Files and Duplicate, Rename and Modify to work wih .Net Framework rather than .NET
        private static void RetardProjectFiles()
        {
            //Path.GetDirectoryName() is used like "cd .." terminal command here because we don't want the Assets folder, we want the root folder
            string projectLocation = Path.GetDirectoryName(Application.dataPath);
            string projectPath = Path.Combine(projectLocation, "Assembly-CSharp.csproj");
            string solutionPath = Path.Combine(projectLocation, $"{Path.GetFileName(projectLocation)}.sln");
            string editorLocation = "";
            string cscScriptPath = "";

            if (!File.Exists(solutionPath) || !File.Exists(projectPath))
            {
                Debug.LogError("Project files could not be found. Go to \"Preferences>External Tools\" and click on \"Regenerate project files\". If the button is not there, make sure the correct external script editor is selected.");
            }
            else
            {
                DetermineEditorInstallLocation(ref projectLocation, ref editorLocation, ref projectPath);
                CreateUnityCscScriptForPlatform(ref editorLocation, ref cscScriptPath);
                CreateDotNetFrameworkProjectFile(ref projectLocation, ref projectPath, ref cscScriptPath);
                CreateSolution(ref projectLocation, ref projectPath, ref solutionPath);
            }
        }

        //TODO: Add new C# script files to the Retarded Project
        private static void UpdateProjectFiles()
        {
            Debug.Log("Update!");
        }

        //TODO: Launch the Retared Solution With MonoDevelop
        private static void OpenProjectFiles()
        {
            Debug.Log("Open!");
        }

        private static string ExtractValueFromLine(string line)
        {
            return line.Split('>')[1].Split('<')[0];
        }

        private static bool DetermineEditorInstallLocation(ref string projectLocation, ref string editorLocation, ref string projectPath)
        {
            try
            {
                string path = "";
                using (StreamReader sr = new StreamReader(projectPath))
                {
                    string line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        if (line.Contains("<HintPath>", StringComparison.Ordinal))
                        {
                            path = ExtractValueFromLine(line);
                            break;
                        }
                    }
                }

                path = Path.GetDirectoryName(path);

                string root = Directory.GetDirectoryRoot(path);
                while (path != root && !path.EndsWith("Editor", StringComparison.Ordinal))
                    path = Directory.GetParent(path).FullName;

                editorLocation = path;

                Debug.Log($"Editor location is determined to be: {editorLocation}");
                return true;
            }
            catch(Exception e)
            {
                Debug.LogError("DetermineEditorInstallLocation failed with error:\n" + e.Message);
                return false;
            }
        }

        private static bool CreateUnityCscScriptForPlatform(ref string editorLocation, ref string cscScriptPath)
        {
            string fileName = "";
            string contents = "";

            RuntimePlatform runtimePlatform = Application.platform;
            if(runtimePlatform == RuntimePlatform.LinuxEditor)
            {
                fileName = "unity_csc_h.sh";
                contents = "#!/bin/bash\r\n\r\nAPPLICATION_CONTENTS=$(dirname \"$0\")/../..\r\n\r\nif [ -f \"$APPLICATION_CONTENTS/Tools/Roslyn/csc\" ];\r\nthen\r\n    CSC_NET_CORE=$APPLICATION_CONTENTS/Tools/Roslyn/csc\r\nelse\r\n    TOPLEVEL=$(dirname \"$0\")/../../../..\r\n    CSC_NET_CORE=$TOPLEVEL/artifacts/buildprogram/Stevedore/roslyn-csc-linux/csc\r\nfi\r\n\r\n    eval \"\\\"$CSC_NET_CORE\\\" /shared /utf8output \"$@\"\"";
            }
            else if(runtimePlatform == RuntimePlatform.WindowsEditor)
            {
                fileName = "unity_csc.bat";
                contents = "@ECHO OFF\r\n\r\nsetlocal\r\n\r\nrem start with editor install layout\r\nset CSC=%~dp0..\\..\\Tools\\Roslyn\\csc.exe\r\n\r\nrem fall back to source tree layout\r\nif not exist \"%CSC%\" set CSC=%~dp0..\\..\\csc\\builds\\Binaries\\Windows\\csc.exe\r\n\r\nif not exist \"%CSC%\" (\r\n\techo Failed to find csc.exe\r\n\texit /b 1\r\n)\r\n\r\n\"%CSC%\" /shared /utf8output %*\r\nexit /b %ERRORLEVEL%\r\n\r\nendlocal\r\n";
            }
            else if (runtimePlatform == RuntimePlatform.OSXEditor)
            {
                //TODO:
                fileName = "";
                contents = "";
            }

            try
            {
                //TEMP
                cscScriptPath = Path.Combine(editorLocation, "Data", "Tools", "RoslynScripts");
                if (!Directory.Exists(cscScriptPath))
                    Directory.CreateDirectory(cscScriptPath);

                cscScriptPath = Path.Combine(cscScriptPath, fileName);

                File.WriteAllText(cscScriptPath, contents);

                Debug.Log($"{cscScriptPath} written successfully");
                return true;
            }
            catch(Exception e)
            {
                Debug.LogError("CreateUnityCscScriptForPlatform failed with error:\n" + e.Message);
                return false;
            }
        }

        private static bool CreateDotNetFrameworkProjectFile(ref string projectLocation, ref string projectPath, ref string cscScriptPath)
        {
            string projectTemplate = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\r\n<Project ToolsVersion=\"4.0\" DefaultTargets=\"Build\" xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">\r\n    <PropertyGroup>\r\n        <LangVersion>latest</LangVersion>\r\n        <CscToolPath>{:cscScriptLocation}</CscToolPath>\r\n        <CscToolExe>{:cscScriptName}</CscToolExe>\r\n    </PropertyGroup>\r\n    <PropertyGroup>\r\n        <Configuration Condition=\" '$(Configuration)' == '' \">Debug</Configuration>\r\n        <Platform Condition=\" '$(Platform)' == '' \">AnyCPU</Platform>\r\n        <ProductVersion>10.0.20506</ProductVersion>\r\n        <SchemaVersion>2.0</SchemaVersion>\r\n        <RootNamespace>\r\n        </RootNamespace>\r\n        <ProjectGuid>{:projectGuid}</ProjectGuid>\r\n        <OutputType>Library</OutputType>\r\n        <AppDesignerFolder>Properties</AppDesignerFolder>\r\n        <AssemblyName>Assembly-CSharp</AssemblyName>\r\n        <TargetFrameworkVersion>{:targetFrameworkVersion}</TargetFrameworkVersion>\r\n        <FileAlignment>512</FileAlignment>\r\n        <BaseDirectory>.</BaseDirectory>\r\n    </PropertyGroup>\r\n    <PropertyGroup Condition=\" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' \">\r\n        <DebugSymbols>true</DebugSymbols>\r\n        <DebugType>full</DebugType>\r\n        <Optimize>false</Optimize>\r\n        <OutputPath>Temp\\Bin\\Debug\\</OutputPath>\r\n        <DefineConstants>{:constantDefinitions}</DefineConstants>\r\n        <ErrorReport>prompt</ErrorReport>\r\n        <WarningLevel>4</WarningLevel>\r\n        <NoWarn>0169</NoWarn>\r\n        <AllowUnsafeBlocks>False</AllowUnsafeBlocks>\r\n    </PropertyGroup>\r\n    <PropertyGroup Condition=\" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' \">\r\n        <DebugType>pdbonly</DebugType>\r\n        <Optimize>true</Optimize>\r\n        <OutputPath>Temp\\bin\\Release\\</OutputPath>\r\n        <ErrorReport>prompt</ErrorReport>\r\n        <WarningLevel>4</WarningLevel>\r\n        <NoWarn>0169</NoWarn>\r\n        <AllowUnsafeBlocks>False</AllowUnsafeBlocks>\r\n    </PropertyGroup>\r\n    <PropertyGroup>\r\n        <NoConfig>true</NoConfig>\r\n        <NoStdLib>true</NoStdLib>\r\n        <AddAdditionalExplicitAssemblyReferences>false</AddAdditionalExplicitAssemblyReferences>\r\n        <ImplicitlyExpandNETStandardFacades>false</ImplicitlyExpandNETStandardFacades>\r\n        <ImplicitlyExpandDesignTimeFacades>false</ImplicitlyExpandDesignTimeFacades>\r\n    </PropertyGroup>\r\n    <ItemGroup>\r\n        {:compileScripts}\r\n    </ItemGroup>\r\n    <ItemGroup>\r\n        {:references}\r\n    </ItemGroup>\r\n    <Import Project=\"$(MSBuildToolsPath)\\Microsoft.CSharp.targets\" />\r\n</Project>";

            string cscScriptLocation = Path.GetDirectoryName(cscScriptPath);
            string cscScriptName = Path.GetFileName(cscScriptPath);
            string projectGuid = "";
#if UNITY_2022_1_OR_NEWER
            string targetFrameworkVersion = "v4.8";
#else
            string targetFrameworkVersion = "v4.7.1";
#endif
            string constantDefinitions = "";
            string compileScripts = "";
            string references = "";

            string[] lines = File.ReadAllLines(projectPath);
            for(int i = 0; i < lines.Length; i++)
            {
                string line = lines[i];

                if(line.Contains("<ProjectGuid>", StringComparison.Ordinal))
                    projectGuid = ExtractValueFromLine(line);
                else if(line.Contains("<DefineConstants>", StringComparison.Ordinal))
                    constantDefinitions = ExtractValueFromLine(line);
                else if (line.Contains("<Compile Include=", StringComparison.Ordinal))
                    compileScripts += line + "\n";
                else if (line.Contains("<Reference Include=", StringComparison.Ordinal))
                {
                    for (int j = i; j < lines.Length; j++)
                    {
                        if (lines[j].Contains("</ItemGroup>", StringComparison.Ordinal))
                            break;
                        references += lines[j] + "\n";
                    }
                    break;
                }
            }

            projectTemplate = projectTemplate.Replace("{:cscScriptLocation}", cscScriptLocation);
            projectTemplate = projectTemplate.Replace("{:cscScriptName}", cscScriptName);
            projectTemplate = projectTemplate.Replace("{:projectGuid}", projectGuid);
            projectTemplate = projectTemplate.Replace("{:targetFrameworkVersion}", targetFrameworkVersion);
            projectTemplate = projectTemplate.Replace("{:constantDefinitions}", constantDefinitions);
            projectTemplate = projectTemplate.Replace("{:compileScripts}", compileScripts);
            projectTemplate = projectTemplate.Replace("{:references}", references);

            string newProjectFileName = $"{Path.GetFileNameWithoutExtension(projectPath)}.MonoDevelop.csproj";
            string newProjectPath = Path.Combine(projectLocation, newProjectFileName);

            try
            {
                File.WriteAllText(newProjectPath, projectTemplate);
            }
            catch (Exception e)
            {
                Debug.LogError("CreateDotNetFrameworkProjectFile failed with error:\n" + e.Message);
                return false;
            }

            Debug.Log($"{newProjectPath} written successfully");
            return true;
        }

        private static bool CreateSolution(ref string projectLocation, ref string projectPath, ref string solutionPath)
        {
            string projectFileName = Path.GetFileName(projectPath);
            string newProjectFileName = $"{Path.GetFileNameWithoutExtension(projectPath)}.MonoDevelop.csproj";
            string newProjectPath = Path.Combine(projectLocation, newProjectFileName);
            string newSolutionPath = Path.Combine(projectLocation, $"{Path.GetFileNameWithoutExtension(solutionPath)}.MonoDevelop.sln");

            string[] lines = File.ReadAllLines(solutionPath);
            for(int i = 0; i < lines.Length; i++)
            {
                if (lines[i].Contains(projectFileName, StringComparison.Ordinal))
                {
                    lines[i] = lines[i].Replace(projectFileName, newProjectFileName);

                    try
                    {
                        File.WriteAllLines(newSolutionPath, lines);
                    }
                    catch(Exception e)
                    {
                        Debug.LogError("CreateSolution failed with error:\n" + e.Message);
                        return false;
                    }

                    Debug.Log($"{newSolutionPath} written successfully");
                    return true;
                }
            }

            Debug.LogError("CreateSolution failed for whatever reason.");
            return false;
        }
    }
}
#endif