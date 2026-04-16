---
name: daily-report
description: "扫描本地 git 仓库的当日提交记录，整理成结构化工作日报，并自动创建飞书云文档。当用户提到写日报、生成日报、整理今日工作、查看今天提交记录并汇总时使用。"
---

# Git 日报生成器

扫描本地 git 仓库当日提交，自动整理为结构化日报并发布到飞书云文档。

## 工作流

### Step 1: 扫描 git 提交

使用 Bash 脚本扫描指定目录下所有 git 仓库的当日提交：

```bash
bash "<skills_dir>/daily-report/scripts/scan-commits.sh" [scan_directory]
```

- `scan_directory`：可选，默认 `c:/development/code/`
- 输出格式为结构化文本，按项目分组

如果用户指定了特定项目目录，直接对该目录执行 git log 即可，无需扫描全部仓库。

### Step 2: 分析提交内容

对扫描结果进行分析整理：

1. **按项目分组**：每个有提交的仓库作为一个独立章节
2. **提取关键信息**：
   - 提交时间、提交消息
   - 变更文件数、新增行数、删除行数
   - 涉及的模块（从文件路径推断）
3. **归纳总结**：
   - 将多次提交归纳为工作项
   - 提炼今日完成的核心工作
   - 推测进行中和明日计划（基于上下文，标注为推测）

### Step 3: 创建飞书云文档

调用 lark-cli 创建日报文档，使用 Lark-flavored Markdown：

```bash
lark-cli docs +create --title "工作日报 - <YYYY年M月D日>" --markdown '<markdown_content>'
```

#### 日报模板

```markdown
<callout emoji="📅" background-color="light-blue">
**日期**：<日期与星期> | **提交人**：<git author> | **项目数**：<N> | **总提交**：<N> 次
</callout>

---

## 今日工作内容

### <项目名称>

> <用一句话概括该项目今日工作>

**共 N 次提交，涉及 N 个文件，新增 N 行，删除 N 行**

| 时间 | 提交内容 | 变更规模 |
|------|----------|----------|
| HH:MM | 提交消息 | N 文件 (+X/-Y) |

**涉及模块**：模块A、模块B

（多个项目重复上述结构）

---

## 工作总结

<grid cols="3">
<column>

<callout emoji="✅" background-color="light-green">
**已完成**

- 工作项 1
- 工作项 2

</callout>

</column>
<column>

<callout emoji="🔄" background-color="light-yellow">
**进行中**

- 工作项（推测）

</callout>

</column>
<column>

<callout emoji="📋" background-color="light-purple">
**明日计划**

- 计划项（推测）

</callout>

</column>
</grid>
```

### Step 4: 返回结果

向用户展示：
1. 文档链接
2. 日报摘要（项目数、提交数、核心工作）

## 注意事项

- 如果当天没有任何提交，告知用户"今日暂无 git 提交记录"，不创建文档
- "进行中"和"明日计划"基于上下文推测，需标注让用户自行调整
- 日报标题中的日期使用中文格式（如"2026年4月15日"）
- 创建文档前无需用户二次确认（用户调用本 Skill 即表示意图明确）
