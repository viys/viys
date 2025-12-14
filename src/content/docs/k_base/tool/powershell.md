---
title: PowerShell 入门教程
---

# PowerShell 入门教程

> 微软 PowerShell 中文文档使用的是机翻，尽量阅读英文版本的官方文档。或在无法理解中文意思时通过将网址中的 `zh-cn` 修改为 `en-us` 来查看英文文档。

https://learn.microsoft.com/powershell/

## 核心命令

> `Get-Help` 和 `Get-Command` 都是在 PowerShell 中发现和理解命令的宝贵资源。

| 命令        | 说明     |
| ----------- | -------- |
| clear、cls  | 清屏     |
| Get-Help    | 获取帮助 |
| Get-Command | 获取命令 |
| Get-Member  | 获取成员 |

### Get-Help

> `Get-Help` 是一个多用途命令，可帮助你了解如何在找到命令后使用命令。 

​	使用 `Get-Help` 查找命令时，它最初会根据输入对命令名称执行通配符搜索。 如果找不到任何匹配项，它将在系统上的所有 PowerShell 帮助文章中执行全面的全文搜索。 如果这也找不到任何结果，它将返回错误。

#### Parameters 参数

> 通过参数可以指定更改命令行为的选项和参数。

​	`Get-Help` 有多个参数，可以指定这些参数来返回整个帮助文章或命令的子集。 若要查看 `Get-Help`的所有可用参数，请使用`Get-Help -Name Get-Help`获取并参阅其帮助文章的 **SYNTAX** 部分。

​	SYNTAX 不是教程，是命令行的“类型签名 + 约束规则”。PowerShell 语法中同特定的符号表示参数的可选、必选、类型、取值范围等，要学会解读下面的符号规则。

1. `[]`方括号

   表示可选，可以有也可以没有。

   例子：

   `[-Path <string>]`中 Path 参数是可选的。

2. `<>`尖括号

   表示参数的类型。

   例子：

   `<string>`需要传入一个字符串。

3. `[[] <>]`双层括号

   表示参数顺序正确时方括号中的内容可以省略。

   例子：

   `Get-Help -Name Get-Process`等效于 `Get-Help Get-Process`，因为 Name 是位置参数（Position 0）。

4. `{A | B | C}`花括号加竖线

   表示只能从其中选择一个。

   例子：

   `-Category {Alias | Cmdlet | Provider}`

   `-Category Cmdlet` ✅
    `-Category Alias` ✅
    `-Category Cat` ❌（不在列表里）

5. `<string[]>`

   方括号跟在类型之后，表示可以接受多个值。

6. `<CommonParameters>`

   所有 PowerShell 命令都支持的通用参数（如 `-Verbose`、`-ErrorAction` 等）。

#### Parameters sets 参数集

> 在使用`Get-Help`命令时，SYNTAX 中有六组不同的参数，每个参数集中至少包含一个唯一参数，使其与其他参数不同。

​	参数集是互斥的。，指定仅存在于一个参数集中的唯一参数后，PowerShell 会限制你使用该参数集中包含的参数。以下每个参数都属于 `Get-Help` cmdlet 的不同参数集。

- 完整（-Full）
- 详细（-Detailed）
- 例子（-Examples）
- 在线（-Online）
- 参数（-Parameter）
- 显示窗口（-ShowWindow）

#### The command syntax 命令语法

> 学习这些语法元素对于熟悉 PowerShell 至关重要，使用 PowerShell 帮助系统的频率越多，记住所有细微差别就越容易。

​	使用`Get-Help`命令查看帮助文档中的 SYNTAX 便是命令语法。

#### Positional parameters 位置参数

> 位置参数允许你提供一个值，而无需指定参数的名称。

​	在位置上使用参数时，必须在命令行上的正确位置指定其值。 可以在命令帮助文章的 **[PARAMETERS](https://learn.microsoft.com/zh-cn/powershell/module/cimcmdlets/get-cimclass?view=powershell-7.5#parameters)** 节中找到参数的位置信息。 显式指定参数名称时，可以按任意顺序使用参数。

#### Switch parameters 交换机参数

> 不需要值的参数称为 switch 参数。

​	参数名后面没有数据类型。当你指定开关参数时，其值为 `true` 。当你不指定开关参数时，其值为 `false` 。如，`Get-ExecutionPolicy -List`。

#### A simplified approach to syntax 语法的简化方法

> 有一种更用户友好的方法可以获取与使用晦涩难懂的命令语法相同的信息,  某些命令并非以纯英文形式提供。使用 `-Full` 参数 `Get-Help` 可以让 PowerShell 返回完整的帮助文章，更轻松地理解命令的用法。

​	使用 `Get-Help -Name Get-Help -Full` 命令输出的帮助信息包含了更多的信息量。同时你也可以使用如下被简化后的命令达到同样的效果。

```powershell
help -Name Get-Help -Full
help Get-Help -Full
```

在电脑上运行该示例，查看其输出结果都包含哪些组成部分。

- NAME（名称）
- SYNOPSIS（概要）
- SYNTAX（语法）
- DESCRIPTION（描述）
- PARAMETERS（参数）
- INPUTS（输入）
- OUTPUTS（输出）
- NOTES（笔记）
- EXAMPLES（例子）
- RELATED LINKS（相关链接）

​	其中 PARAMETERS 是比较重要的部分，其中包含了参数的说明和特性。

```powershell
...
	-Name <System.String[]>
        Specifies an array of names. This cmdlet gets only commands that
        have the specified name. Enter a name or name pattern. Wildcard
        characters are permitted.

        To get commands that have the same name, use the All parameter. When
        two commands have the same name, by default, `Get-Command` gets the
        command that runs when you type the command name.

        Required?                    false
        Position?                    0
        Default value                None
        Accept pipeline input?       True (ByPropertyName, ByValue)
        Accept wildcard characters?  true
...
```

​	关于 `Name` 参数，它是不是必须的（Required）、参数位置（Position）、默认值（Default value）、是否接受管道输入（pipeline input）和是否支持通配符（wildcard characters）都是很重要的信息。

##### Finding commands with Get-Help 使用 Get-Help 查找命令

​	使用 `Get-Help` 命令查找其他命令时，可以使用 * 号作为通配符来匹配搜索词。如，`help *process*`。如果搜索仅仅找到一个匹配的项，`Get-Help` 将会直接显示帮助内容，而不是列出搜索结果。

#### Updating help 更新帮助

​	应定期在计算机上运行 `Update-Help -UICulture en-US` cmdlet，以获取最新的帮助内容。

### Get-Command

> `Get-Command` 是另一个多用途命令，可帮助你查找命令。

​	 在没有任何参数的情况下运行 `Get-Command` 时，它会返回系统上所有 PowerShell 命令的列表。 还可以使用 `Get-Command` 获取类似于 `Get-Help`的命令语法。

​	 可以使用 `Get-Help` 显示 `Get-Command`的帮助文章。 还可以将 `Get-Command` 与 `-Syntax` 参数一起使用，以查看任何命令的语法。 此快捷方式可帮助你快速确定如何在不浏览其帮助内容的情况下使用命令。

```powershell
PS > Get-Command -Name Get-Command -Syntax
Get-Command [[-ArgumentList] <Object[]>] [-Verb <string[]>] [-Noun <string[]>] [-Module <string[]>] [-FullyQualifiedModule <ModuleSpecification[]>] [-TotalCount <int>] [-Syntax] [-ShowCommandInfo] [-All] [-ListImported] [-ParameterName <string[]>] [-ParameterType <PSTypeName[]>] [<CommonParameters>]

Get-Command [[-Name] <string[]>] [[-ArgumentList] <Object[]>] [-Module <string[]>] [-FullyQualifiedModule <ModuleSpecification[]>] [-CommandType <CommandTypes>] [-TotalCount <int>] [-Syntax] [-ShowCommandInfo] [-All] [-ListImported] [-ParameterName <string[]>] [-ParameterType <PSTypeName[]>] [-UseFuzzyMatching] [-FuzzyMinimumDistance <uint>] [-UseAbbreviationExpansion] [<CommonParameters>]
```

### Get-Member

> 在 PowerShell 中，每个项目或状态都是一个可以浏览和操作的对象实例。 `Get-Member` cmdlet 是 PowerShell 提供的主要对象发现工具之一，它可以揭示对象的特征。

​	`Get-Member` 可以深入了解与 PowerShell 命令关联的对象（objects）、特性（Properties）和方法（Methods）。可以将任何生成基于对象的输出的 PowerShell 命令通过管道传递给 `Get-Member` 。当将命令的输出通过管道传递给 `Get-Member` 时，它会显示命令返回对象的结构，并详细说明其特性和方法。

- **Properties**: The attributes of an object.
- **Methods**: The actions you can perform on an object.

#### Properties 特性

​	通过 `Get-Service` cmdlet 来检索 Windows 时间服务的详情信息，如下。

```powershell
PS > Get-Service -Name w32time

Status   Name               DisplayName
------   ----               -----------
Running  w32time            Windows Time
```

​	`Get-Service -Name w32time` 命令不是在打印文本，而是在做一件很关键的事返回一个 .NET 对象。具体来说，它返回的是 `System.ServiceProcess.ServiceController`，这个对象代表 Windows 的一个服务实例（w32time = Windows Time 服务）。

​	关于 `Get-Service -Name w32time | Get-Member ` 命令 `Get-Service` 列出 w32time 的所有可用属性和方法，并将返回的 .NET 对象（System.ServiceProcess.ServiceController）其传递给 `Get-Member` 。`Get-Member` 会查看这个 .NET 对象它是什么类型、它有哪些特性和哪些方法。一句话总结就是这个命令可以告诉我们 w32time 这个对象能干什么。

```powershell
PS > Get-Service -Name w32time | Get-Member

   TypeName: System.Service.ServiceController#StartupType

Name                      MemberType    Definition
----                      ----------    ----------
Name                      AliasProperty Name = ServiceName
RequiredServices          AliasProperty RequiredServices = ServicesDependedOn
Disposed                  Event         System.EventHandler Disposed(System.Object, System.EventArgs)
Close                     Method        void Close()
...
BinaryPathName            Property      System.String {get;set;}
...
ToString                  ScriptMethod  System.Object ToString();
```

​	还可以通过 `Get-Service -Name w32time | Select-Object -Property *` 和 `Get-Service -Name w32time | Select-Object -Property Status, DisplayName, Can*` 过滤出特性信息。

#### Methods 方法

> 方法是可以对对象执行的操作。

​	可以通过 `Get-Service -Name w32time | Get-Member -MemberType Method` 命令过滤出 w32time 的方法。

## One-Liners and the pipeline 单行式命令与管道

### One-Liners 单行式命令

> PowerShell 单行式命令是一个连续的管道

​	例如，考虑以下示例：该命令在多个物理行上扩展，但它是 PowerShell 单行式命令，因为它形成了一个连续的管道。 建议在管道符号处断行很长的单行式命令，这是 PowerShell 中的自然断点，以增强可读性和清晰度。这种对换行符的策略性使用增强了可读性，同时不影响管道的顺畅进行。

```powershell
Get-Service |
    Where-Object CanPauseAndContinue -EQ $true |
    Select-Object -Property *
```

### Filter Left 前置过滤

> 在管道中提前筛选结果，实现这一点需要在初始命令上使用参数应用过滤器，通常在管道的开头进行。

​	如 `Get-Service -Name w32time` 等同于 `Get-Service | Where-Object Name -EQ w32time`。

#### Command sequencing for effective filtering

​	排列命令的顺序，尤其是在过滤时，非常重要。例如，假设你使用 `Select-Object` 选择特定属性，并使用 `Where-Object` 进行过滤。在这种情况下，必须先应用过滤。否则，必要的属性可能不会在管道中可用，导致结果无效或错误。

### The Pipeline 管道

> 可以将一个命令的输出作为另一个命令的输入。

​	PowerShell 管道传递的不是文本，而是结构化对象，绑定规则决定了命令如何自动协作。

### PowerShellGet

​	PowerShellGet 是 PowerShell 用来管理模块的工具，支持在 NuGet 仓库中查找、安装、更新和发布模块。PowerShell 5.0 及以上版本默认自带该模块，PowerShell 3.0 以上也可以单独安装。
​	 PowerShell Gallery 是微软托管的公共模块仓库，大多数模块和脚本来自社区贡献，因此在项目中使用前应先查看源码，并在测试环境中验证，避免直接在生产环境使用。

### Finding pipeline input the easy way

​	MrToolkit 模块中提供了 `Get-MrPipelineInput` 函数，用于快速查看某个命令哪些参数支持管道输入。它可以直接显示三类关键信息：哪些参数可以接收管道输入、每个参数期望的对象类型，以及参数是通过值（ByValue / 按类型）还是属性名（ByPropertyName）接收管道输入。
 	使用该函数可以省去手动翻阅和分析完整帮助文档的过程，更直观地理解命令的管道绑定规则。例如，对 `Stop-Service` 运行 `Get-MrPipelineInput` 可以清楚地看到：`InputObject` 参数接收 `ServiceController` 对象并通过管道按值绑定，而 `Name` 参数接收字符串，既支持按值绑定，也支持按属性名绑定。这种方式大幅降低了理解和使用 PowerShell 管道的成本。

# 后续学习

​	由于前几章官方文档为机器翻译，很多概念直译成中文难以理解，因此编写了本入门文档；后续章节主要涉及语法学习，建议直接参考官方英文文档或中文文档。

- [Formatting, aliases, providers, comparison](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/05-formatting-aliases-providers-comparison?view=powershell-7.5)

- [Flow control](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/06-flow-control?view=powershell-7.5)
- [Working with WMI](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/07-working-with-wmi?view=powershell-7.5)
- [PowerShell remoting](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/08-powershell-remoting?view=powershell-7.5)
- [Functions](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/09-functions?view=powershell-7.5)
- [Script modules](https://learn.microsoft.com/en-us/powershell/scripting/learn/ps101/10-script-modules?view=powershell-7.5)





