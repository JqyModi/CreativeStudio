# 创意内容工作室MVP设计文档

## 1. 概述
创意内容工作室是一个AI驱动的视觉内容创作平台，旨在帮助用户通过文字描述或图像上传快速生成创意视觉内容。

## 2. 核心功能模块

### 2.1 仪表盘页面
- **用户统计数据**：
  - 本月创作数量（饼图展示不同类型内容占比）
  - 进行中项目列表（显示项目名称、进度条、最后修改时间）
  - 项目完成率统计（周/月趋势图）
- **使用限制**：
  - 今日剩余生成次数（进度条形式，显示25/50）
  - 次日重置倒计时（12:00:00）
  - 会员升级提示（当接近限额时显示）
- **快速创作入口**：
  - 悬浮操作按钮（+号图标），点击展开文字生成/图像上传选项
  - 语音输入快捷入口（麦克风图标）
  - 历史模板推荐区域（最近使用的3个模板）
- **最近项目列表**：
  - 网格布局展示最近8个项目
  - 每个项目卡片包含缩略图、名称、状态标签（进行中/已完成）
  - 支持按时间/名称排序，可通过顶部筛选器过滤

### 2.2 文字生成页面
- **用户输入区域**：
  - 多行文本输入框（支持500字符，实时字数统计）
  - 智能提示系统（根据输入内容推荐关键词/风格）
  - 格式化工具栏（粗体、斜体、项目符号等基础格式）
  - 历史提示词快速插入（最近使用的5个提示词）
- **语音输入功能**：
  - 实时语音转文字（带波形动画反馈）
  - 支持暂停/继续录音（最大60秒）
  - 自动标点添加与错误修正建议
  - 多语言切换选项（中/英/日）
- **生成控制**：
  - 智能生成按钮（根据输入长度显示预估时间）
  - 高级参数面板（可展开设置：风格强度、创意度、排除元素）
  - 历史版本快速切换（最近3次生成记录）
- **状态反馈**：
  - 进度环形指示器（实时显示处理阶段）
  - 预估完成时间显示（00:00格式）
  - 系统资源占用提示（当请求过多时显示排队状态）

### 2.3 图像上传页面
- **上传区域**：
  - 支持拖拽和点击上传（最大20MB，支持JPG/PNG格式）
  - 实时预览（上传后自动显示缩略图，支持旋转/裁剪）
  - 文件数量限制（单次最多上传5张）
  - 格式验证提示（不符合要求时即时反馈）
- **描述输入**：
  - 可选但推荐的描述字段（200字符限制）
  - 智能建议（基于图像内容自动生成描述草稿）
  - 多语言支持（中/英/日，与语音输入一致）
  - 关键词标签推荐（根据图像识别自动添加）
- **生成控制**：
  - 风格选择器（默认、艺术、写实等预设风格）
  - 衍生内容生成按钮（带处理时间预估）
  - 高级参数选项（保留原图特征强度、色彩饱和度调节）
  - 参考图混合功能（可上传多张参考图进行风格融合）
- **状态反馈**：
  - 分阶段进度指示（上传、分析、生成）
  - 实时预览生成过程（低分辨率到高清渐进式加载）
  - 错误处理（格式不符、过大文件等明确提示）

### 2.4 文字生成结果页面
- **多标签内容展示**：
  - 图像标签页：网格布局展示4张高清图像（1080p），支持点击放大查看细节
  - 文案标签页：分栏显示长文案（适用于文章）与短文案（适用于社交媒体）
  - 组合内容标签页：图文混排展示模板，可调整图文比例和布局样式
  - 相似内容推荐区：基于当前结果生成的3个变体（底部水平滚动）
- **重新生成控制**：
  - 一键重新生成全部内容（保留当前参数设置）
  - 针对单个内容类型重新生成（如仅重新生成图像或文案）
  - 智能调整建议（系统根据历史数据推荐参数优化方向）
  - 生成历史对比（可查看最近3次生成结果的差异）
- **内容导出**：
  - 高清图像导出（支持PNG/JPG格式，300dpi）
  - 文案导出（Markdown/Word/PDF格式）
  - 社交媒体适配导出（自动裁剪为各平台推荐尺寸）
  - 项目归档功能（将当前结果保存至项目库，自动关联原始提示词）

### 2.5 图像上传结果页面
- **多标签内容展示**：
  - 衍生图像标签页：网格布局展示4张高清图像（可调整显示数量），支持逐帧查看生成过程
  - 相关文案标签页：自动生成与图像匹配的文案，支持编辑和多语言切换
  - 风格变化标签页：提供3种不同风格变体（点击切换预览），支持强度滑块调节
  - 对比工具：原始图像与生成结果并排对比，可调整透明度查看差异
- **重新生成控制**：
  - 一键重新生成全部内容（保留原始图像和参数）
  - 针对单个风格变体重新生成（独立于其他结果）
  - 智能参数优化（基于用户偏好自动调整风格强度）
  - 参考历史对比（显示最近3次生成结果的风格参数变化）
- **内容导出**：
  - 原始分辨率图像导出（保留EXIF数据，最大支持4K）
  - 风格参数导出（可保存当前风格设置为模板）
  - 批量导出功能（选择多个结果一次性导出）
  - 版权声明嵌入（可选添加水印或版权信息)

## 3. 用户界面设计

### 3.1 视觉风格
- **设计系统规范**：
  - 圆角系统：基础元素8px，卡片12px，按钮24px（根据Figma设计系统）
  - 间距系统：4px基础单位，主要间距层级(8/16/24/32/40)
  - 阴影层次：3级深度阴影（卡片/浮层/模态框），支持暗色模式自动适配
  - 微交互规范：所有可点击元素有0.2s平滑过渡效果
- **色彩系统**：
  - 主渐变：#6A11CB → #2575FC（线性渐变135°，用于主要按钮和标题）
  - 辅助色：#FF6B6B（操作警示），#4ECDC4（成功状态），#FFD166（提示信息）
  - 文字对比度：确保WCAG AA合规（正文16px/#333333，标题24px/#222222）
  - 暗色模式：自动检测系统偏好，使用深灰(#121212)替代纯黑
- **响应式设计**：
  - 响应式断点：320px(手机)、768px(平板)、1024px(小桌面)、1200px(桌面)
  - 移动优先布局：主要内容区域宽度限制在414px（iPhone Pro Max）
  - 触控优化：关键操作区域最小48×48px，间距避免误触
  - 媒体查询：针对不同设备自动调整导航栏、字体大小和间距
- **卡片设计规范**：
  - 基础卡片：1px #E0E0E0边框，8px圆角，16px内边距，悬停提升4px
  - 项目卡片：包含图像预览区(200×200px)、信息区(120px)和操作区
  - 交互反馈：选择状态有2px主色描边，加载状态显示骨架屏
  - 布局层次：通过阴影深度(0-3)和z-index体现元素层级关系

### 3.2 交互流程
- **1. 首页仪表盘**：
  - 自动数据加载：进入页面时发起API请求获取用户数据（超时10秒）
  - 空状态处理：无项目时显示引导卡片和3个示例作品
  - 限额提醒：当剩余次数<20%时显示醒目提示条和升级按钮
  - 快速创作入口：悬浮按钮有0.3s呼吸动画，点击后展开扇形菜单
- **2. 创作选择**：
  - 双通道入口：顶部导航栏固定入口 + 底部悬浮按钮（点击触发模态框）
  - 手势操作：向右滑动进入文字生成，向左滑动进入图像上传
  - 禁用状态处理：当达到生成限额时入口显示为禁用态并提示
  - 智能推荐：根据用户历史行为排序创作选项（文字/图像优先级）
- **3. 内容输入**：
  - 文字输入验证：实时检查敏感词/字符限制，错误时震动反馈
  - 图像上传反馈：拖拽区域高亮，文件类型验证即时提示
  - 输入辅助：自动保存草稿到本地存储（30分钟有效期）
  - 模式切换：文字/图像页面可通过顶部标签无缝切换
- **4. 内容生成**：
  - 阶段进度：显示3个阶段（准备/处理/生成）及预计时间
  - 可中断操作：生成过程中可点击停止按钮（保留部分结果）
  - 错误处理：网络中断时自动重试3次并保存上下文
  - 系统负载提示：高负载时显示排队位置和预估等待时间
- **5. 结果展示**：
  - 默认激活标签：根据输入方式自动选择主标签（文字→图像，图像→衍生）
  - 渐进式加载：低分辨率预览→高清结果（带加载骨架屏）
  - 交互提示：首次使用显示标签切换的引导手势动画
  - 多结果管理：支持左右滑动切换不同生成批次的结果
- **6. 结果操作**：
  - 智能导出推荐：根据内容类型推荐最佳导出格式
  - 批量操作：支持多选结果进行统一归档或删除
  - 版本控制：保存时自动创建版本快照（保留最近10个版本）
  - 社交分享：一键分享到主流平台（自动适配平台尺寸要求）

### 3.3 导航结构
- **顶部导航栏**：
  - 返回按钮：带页面过渡动画，长按显示导航历史（最近3页）
  - 页面标题：居中显示，根据页面内容动态变化（最大18px字体）
  - 辅助操作：右上角设置/帮助图标（根据不同页面显示上下文相关操作）
  - 面包屑导航：复杂流程中显示当前位置层级（如：仪表盘 > 文字生成 > 结果）
- **底部导航系统**：
  - 悬浮创作按钮：主色渐变圆形按钮（直径64px），点击展开扇形菜单（文字/图像/语音）
  - 主要功能标签：底部标签栏包含[首页、项目、消息、个人]（4个核心入口，带未读提示）
  - 动态调整：在内容生成过程中，临时替换为进度环形指示器和取消按钮
  - 手势支持：上滑呼出高级导航菜单（最近页面快速切换，支持拖拽排序）
- **页面内导航**：
  - 标签页系统：结果页面的4种内容类型（图像、文案、组合、推荐）
  - 滑动导航：左右滑动切换不同内容类型，带惯性滚动和弹性反馈
  - 索引指示器：底部显示当前标签位置的小圆点（最多4个标签）
  - 手势提示：首次使用显示滑动手势的引导动画（持续3秒）
- **高级导航功能**：
  - 快捷跳转：从项目列表直接进入结果页面特定标签（保留上下文）
  - 深度链接：支持从外部链接直接打开指定内容（需身份验证）
  - 导航历史：保留最近5次操作路径，可快速回溯（支持前进/后退）
  - 无障碍导航：支持语音指令（"返回首页"）和键盘Tab键导航

## 4. 页面结构分析

### 4.1 主要功能页面
1. **仪表盘页面**
   - **布局结构**:
     - 顶部横幅区：用户头像/名称/会员状态（20%高度）
     - 中央统计网格：3×2响应式网格（6个数据卡片：创作数量、项目进度、使用限额等）
     - 快速创作悬浮按钮：右下角固定FAB（直径64px，z-index 100）
     - 最近项目列表：网格布局（桌面4列/移动2列，带无限滚动）
   - **响应式行为**:
     - 桌面端：侧边栏导航(240px)+主内容区（自动填充剩余空间）
     - 平板端：单列布局，统计卡片变为2列，导航栏折叠为汉堡菜单
     - 移动端：全屏内容，顶部导航栏简化，FAB按钮放大至72px
   - **关键组件**:
     - 数据卡片：12px圆角，1px #E0E0E0边框，悬停提升4px
     - 项目卡片：200×200px图像区+120px信息区，带选择态描边
     - 空状态：3个示例作品卡片+引导创建按钮

2. **文字生成页面**
   - **输入区域结构**:
     - 顶部控制栏：标签切换（文字/图像）+ 返回按钮
     - 主内容区：弹性高度文本域（最小200px，随内容扩展）
     - 智能辅助区：关键词推荐面板（滑入式动画，z-index 50）
     - 生成控制区：固定底部工具栏（含高级参数展开面板）
   - **交互组件**:
     - 文本域：实时语法检查（错误标红波浪线），500字符限制提示条
     - 语音输入：波形动画反馈区（高度40px，随声音动态变化）
     - 历史提示词：底部抽屉式面板（上滑呼出，保留最近5条）
     - 参数面板：半透明模态层（点击遮罩收起，支持手势拖拽）
   - **状态反馈**:
     - 进度指示器：顶部进度环（直径24px，动态填充）
     - 队列提示：当系统负载高时显示排队位置（"当前第3位"）

3. **图像上传页面**
   - **上传区域结构**:
     - 虚线框上传区：中央区域（占屏幕60%高度），含图标/文字提示
     - 多文件预览：上传后自动排列为网格（最大5张，3列布局）
     - 工具栏：固定底部（旋转/裁剪/删除按钮，带操作反馈）
     - 描述输入：可折叠面板（默认关闭，点击展开）
   - **核心组件**:
     - 拖拽区域：悬停时边框变为主色，添加粒子动画反馈
     - 图像预览：缩略图带操作按钮（悬浮显示编辑图标）
     - 格式验证：实时显示文件状态（✓支持格式，×不支持）
     - 风格选择器：水平滚动标签栏（默认选中"默认"，带渐变指示条）
   - **错误状态**:
     - 过大文件：红色脉冲动画+"文件超过20MB"提示
     - 无效格式：震动反馈+显示支持格式列表（JPG/PNG）

4. **文字生成结果页面**
   - **标签页布局**:
     - 固定顶部标签栏：4个标签页（图像/文案/组合/推荐）
     - 内容区域：弹性高度，适配不同内容类型
     - 工具栏：动态按钮组（根据标签内容变化）
   - **图像标签页**:
     - 2×2网格布局：每个项目200×200px预览区+操作按钮
     - 悬停效果：缩放1.05倍+阴影加深，显示"查看详情"提示
     - 导出按钮：每个项目右上角（保存图标，点击弹出格式选项）
   - **文案标签页**:
     - 分栏设计：左栏长文案（60%宽度），右栏短文案（40%宽度）
     - 格式工具：顶部格式切换器（Markdown/HTML/纯文本）
     - 复制按钮：每段文案右上角（点击后变成功提示）
   - **组合内容**:
     - 可拖拽布局：图文元素自由排列，实时预览变化
     - 模板库：侧边栏可选布局模板（点击应用，0.3s过渡动画）

5. **图像上传结果页面**
   - **多标签架构**:
     - 衍生图像：4×1水平滚动（支持手势拖拽，惯性滚动）
     - 相关文案：可编辑文本区+语言切换器（中/英/日）
     - 风格变化：3个预设卡片（点击切换，带风格名称标签）
   - **对比工具**:
     - 分屏布局：左侧原始图，右侧生成结果（可调节分割线位置）
     - 透明度滑块：底部控制条（0%-100%，实时预览变化）
     - 快速切换：双击图像区域切换显示模式（分屏/单图）
   - **高级功能**:
     - 风格参数导出：底部抽屉面板（含参数名称/值/应用按钮）
     - 批量操作：多选模式（长按进入，显示选中数量计数器）
     - 版权水印：半透明浮动控件（拖拽调整位置，实时预览）

### 4.2 导航结构
- **页面路由架构**：
  - 核心路由：/dashboard（仪表盘）、/text-gen（文字生成）、/image-upload（图像上传）、/results/:type（结果页）
  - 嵌套路由：结果页使用动态路由参数（/results/image、/results/text）保持上下文
  - 懒加载：按需加载页面资源，首屏加载时间<1.5秒（基于React.lazy）
  - 路由守卫：关键操作前检查生成限额，超出时重定向至升级页面
- **导航状态管理**：
  - 历史堆栈：Redux存储最近5个页面状态（含查询参数），支持前进/后退
  - 上下文传递：页面跳转时携带必要数据（如原始提示词、图像数据）
  - 状态持久化：关键导航数据存入localStorage（30分钟有效期）
  - 恢复机制：页面刷新后自动恢复最近操作状态（限2分钟内）
- **页面过渡系统**：
  - 基础动画：页面切换使用0.3s平滑过渡（右滑进入/左滑退出）
  - 特殊场景：内容生成中跳转显示确认模态框（避免数据丢失）
  - 结果页过渡：标签切换使用0.2s弹性动画，带手势拖拽反馈
  - 错误处理：无效路由显示404页面，3秒后自动重定向至仪表盘
- **导航性能优化**：
  - 预加载机制：悬停FAB按钮时预加载创作页面资源
  - 缓存策略：结果页内容缓存24小时（ETag验证）
  - 按需渲染：非活跃标签页暂停渲染（节省60%GPU资源）
  - 离线支持：关键导航路径预缓存，无网络时显示简化版界面
- 底部悬浮按钮提供全局访问
- 标签页导航在结果页面中切换内容类型

## 5. 技术方案设计（iOS 纯本地工具App）

### 5.1 系统架构
- **客户端架构**：
  - SwiftUI 5.0 + Swift 5.9 完整实现UI层（零Web视图）
  - 架构模式：MVVM + 本地状态协调器（无网络路由）
  - 状态管理：Combine框架 + @ObservableObject + SwiftData（全离线存储）
  - **移除网络层**：完全消除URLSession等网络依赖
  - 动画系统：SwiftUI原生动画 + Core Animation处理复杂交互动画
- **AI核心处理**：
  - **完全本地AI引擎**：
    • 图像生成：Image Playground框架（iOS 18+原生支持）
    • 文案生成：Foundation Models框架（设备端大语言模型）
    • 风格迁移：Core ML定制神经网络（Metal加速）
    • 无任何网络API调用，纯设备端处理
  - **模型管理**：
    • 文案模型：Foundation Models自动下载（首次使用时按需安装）
    • 图像模型：Image Playground内置模型（无需额外下载）
    • 内存优化：系统级模型缓存管理（NSCache自动回收）
- **本地资源处理**：
  - 图像处理：Photos框架直接访问相册（无上传流程）
  - 语音输入：SFSpeechRecognizer完全离线模式
  - 文件导出：通过UIDocumentPickerViewController直接保存到本地
  - 设备存储：SwiftData管理生成内容（自动清理策略）

### 5.2 数据模型设计（纯本地）
- **本地存储**：
  - SwiftData实体（完全离线）：
    • UserQuota: id, dailyLimit(50), usedToday, resetTime
    • Project: id, name, createdAt, status, generationResults
    • GenerationResult: id, prompt, images, texts, styleParams, createdAt
  - 内存优化：
    • 活动对象池：保留最近3个生成会话（自动释放非活跃对象）
    • 图像缓存：使用Metal纹理缓存（最大占用设备内存30%）
    • 文件分片：大图像自动分割为Metal纹理块（4K→1080p×4）
- **配额系统**：
  - 本地验证机制：
    • 每日限制存储在UserDefaults（kSecAttrAccessibleAfterFirstUnlock）
    • 重置时间基于Calendar.current.date(byAdding: .day)
    • 会员状态：通过StoreKit验证本地订阅状态
  - 安全措施：
    • 重置时间戳加密：AES-256加密UserDefaults键值
    • 防篡改：使用FileWrapper封装关键计数数据
- **内容管理**：
  - 存储路径：
    • 生成图像：~/Documents/GeneratedImages (NSSearchPathForDirectoriesInDomains)
    • 项目数据：SwiftData容器 (NSPersistentContainer)
  - 版本控制：
    • 采用NSFileVersion实现自动版本保存
    • 通过NSUndoManager管理编辑历史（最近20步）
  - 本地索引：
    • Core Spotlight集成离线内容搜索
    • 通过NSPredicate实现多条件过滤（提示词/日期/类型）

### 5.3 安全设计（纯设备端）
- **隐私保护**：
  - 零远程数据：所有用户数据存储在App沙盒内（~Documents）
  - 隐私清单：PrivacyInfo.xcprivacy明确声明：
    • com.apple.security.files.user-selected.read-write (相册访问)
    • com.apple.developer.kernel.prevent-sleep (生成期间保持唤醒)
  - 数据隔离：通过FileProtectionType.complete保护生成内容
- **内容安全**：
  - 实时检测：Apple Content Safety API本地扫描（iOS 17+）
  - 输入过滤：MLTextClassifier识别敏感内容（内置语言模型）
  - 水印系统：CoreImage自动生成不可见数字水印（StegaStamp）
  - 无网络校验：完全移除服务端验证环节
- **合规实现**：
  - COPPA合规：本地年龄验证（DatePicker选择出生日期）
  - 中国法规：
    • 生成内容水印：「AI生成」角标（符合网信办要求）
    • 内容过滤：内置敏感词库（定期通过TestFlight更新）
  - App Store审核：
    • 私有API规避：通过SwiftLint确保零私有API使用
    • 本地模型：MLModel格式通过App Review审核

### 5.4 性能优化（设备端专项）
- **AI处理优化**：
  - 模型部署：
    • Image Playground：原生支持多种艺术风格（动漫、油画、素描等）
    • Foundation Models：多语言支持（中/英/日）本地推理
  - 动态调整：根据BatteryState切换性能模式（高电量→高清输出）
  - 进度控制：生成中断时自动保存中间结果（Metal检查点）
- **UI流畅性**：
  - 渐进渲染：
    • 低分辨率预览（0.5s内）→ 高清输出（可中断）
    • 使用Core Image渐进式滤镜
  - 内存管理：
    • Metal资源复用：VRAM分配器智能管理纹理
    • 通过DispatchSource.timer监控内存压力
- **设备适应性**：
  - 机型分级：
    • A16以下：基础图像生成质量（512×512）
    • A16+：高清图像生成（1024×1024）+ 多风格并行
  - 温控保护：
    • 检测thermalState，高温时自动暂停生成
    • 通过ProcessInfo.thermalState监控设备状态
  - 电池保护：
    • 电量<20%时禁用高清生成模式
    • 后台任务自动暂停（通过ProcessInfo.isLowPowerMode)

## 6. 代码结构规划

### 6.1 项目目录结构
```
CreativeStudio/
├── Sources/
│   ├── App/                          # 应用入口和主协调器
│   │   ├── CreativeStudioApp.swift   # SwiftUI应用主入口
│   │   ├── AppCoordinator.swift      # 应用状态协调器
│   │   └── AppConfig.swift           # 应用配置管理
│   │
│   ├── Presentation/                 # UI层（按功能模块划分）
│   │   ├── Dashboard/                # 仪表盘模块
│   │   │   ├── Views/                # 视图组件
│   │   │   ├── ViewModels/           # 视图模型
│   │   │   └── Coordinators/         # 模块协调器
│   │   ├── TextGeneration/           # 文字生成模块
│   │   ├── ImageUpload/              # 图像上传模块
│   │   ├── Results/                  # 结果展示模块
│   │   └── Shared/                   # 共享UI组件
│   │
│   ├── Domain/                       # 业务逻辑层
│   │   ├── Models/                   # 数据模型定义
│   │   ├── UseCases/                 # 业务用例实现
│   │   ├── Repositories/             # 数据仓库协议
│   │   └── Services/                 # 核心服务接口
│   │
│   ├── Data/                         # 数据层
│   │   ├── Repositories/             # 仓库具体实现
│   │   ├── Local/                    # 本地数据源
│   │   │   ├── SwiftDataStorage.swift # SwiftData存储管理
│   │   │   └── UserDefaultsStorage.swift # UserDefaults封装
│   │   └── Services/                 # 系统服务实现
│   │
│   ├── AI/                           # AI核心处理层
│   │   ├── TextGeneration/           # 文案生成模块
│   │   │   ├── FoundationModelsService.swift # Foundation Models集成
│   │   │   └── TextGenerationUseCase.swift   # 文案生成用例
│   │   ├── ImageGeneration/          # 图像生成模块
│   │   │   ├── ImagePlaygroundService.swift  # Image Playground集成
│   │   │   └── ImageGenerationUseCase.swift  # 图像生成用例
│   │   └── Extensions/               # AI框架扩展
│   │
│   └── Extensions/                   # Swift系统扩展
│       ├── Foundation/               # Foundation扩展
│       ├── SwiftUI/                  # SwiftUI扩展
│       └── UIKit/                    # UIKit扩展（如需要）
│
├── Resources/                        # 资源文件
│   ├── Assets.xcassets/              # 图像资源
│   ├── Preview Content/              # 预览资源
│   ├── Localization/                 # 本地化文件
│   └── PrivacyInfo.xcprivacy         # 隐私清单
│
├── Tests/                            # 测试代码
│   ├── UnitTests/                    # 单元测试
│   └── UITests/                      # UI测试
│
└── CreativeStudio.xcodeproj/         # 项目文件
```

### 6.2 核心模块详细设计

#### 6.2.1 App模块
```swift
// CreativeStudioApp.swift
@main
struct CreativeStudioApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(appCoordinator)
        }
    }
}

// AppCoordinator.swift
class AppCoordinator: ObservableObject {
    @Published var userQuota: UserQuota
    @Published var currentProject: Project?
    
    func navigateToTextGeneration() { }
    func navigateToImageUpload() { }
    func navigateToResults(for project: Project) { }
}
```

#### 6.2.2 AI核心模块

##### 文案生成服务
```swift
// FoundationModelsService.swift
class FoundationModelsService {
    private let textGenerator: MLTextGenerator
    
    func generateText(from prompt: String, style: TextStyle) async throws -> String {
        // 调用Foundation Models生成文案
    }
    
    func availableLanguages() -> [Language] { }
}

// TextGenerationUseCase.swift
struct TextGenerationUseCase {
    let service: FoundationModelsService
    let repository: GenerationRepository
    
    func execute(prompt: String, parameters: GenerationParams) async throws -> TextResult {
        // 执行文案生成业务逻辑
    }
}
```

##### 图像生成服务
```swift
// ImagePlaygroundService.swift
class ImagePlaygroundService {
    private let imageGenerator: ImageGenerator
    
    func generateImage(from prompt: String, style: ArtStyle) async throws -> UIImage {
        // 调用Image Playground生成图像
    }
    
    func availableStyles() -> [ArtStyle] { }
}

// ImageGenerationUseCase.swift
struct ImageGenerationUseCase {
    let service: ImagePlaygroundService
    let repository: GenerationRepository
    
    func execute(prompt: String, parameters: ImageGenerationParams) async throws -> ImageResult {
        // 执行图像生成业务逻辑
    }
}
```

#### 6.2.3 数据层设计

##### SwiftData模型
```swift
// Models/UserQuota.swift
@Model
class UserQuota {
    var dailyLimit: Int
    var usedToday: Int
    var resetTime: Date
    
    func resetIfNeeded() { }
    func canGenerate() -> Bool { }
}

// Models/Project.swift
@Model
class Project {
    var id: UUID
    var name: String
    var createdAt: Date
    var status: ProjectStatus
    var generationResults: [GenerationResult]
}

// Models/GenerationResult.swift
@Model
class GenerationResult {
    var id: UUID
    var prompt: String
    var images: [Data]  // JPEG格式图像数据
    var texts: [String]
    var styleParams: StyleParameters
    var createdAt: Date
}
```

##### 本地存储服务
```swift
// SwiftDataStorage.swift
class SwiftDataStorage {
    private let container: NSPersistentContainer
    
    func saveProject(_ project: Project) async throws { }
    func fetchProjects() async throws -> [Project] { }
    func deleteProject(_ project: Project) async throws { }
    
    func saveGenerationResult(_ result: GenerationResult) async throws { }
    func fetchGenerationResults(for project: Project) async throws -> [GenerationResult] { }
}

// UserDefaultsStorage.swift
class UserDefaultsStorage {
    private let userDefaults: UserDefaults
    
    func saveUserQuota(_ quota: UserQuota) { }
    func loadUserQuota() -> UserQuota? { }
    
    func saveAppSettings(_ settings: AppSettings) { }
    func loadAppSettings() -> AppSettings? { }
}
```

#### 6.2.4 UI层架构

##### Dashboard模块
```swift
// DashboardView.swift
struct DashboardView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var viewModel: DashboardViewModel
    
    var body: some View {
        ScrollView {
            StatsGridView()
            QuickActionsView()
            RecentProjectsView()
        }
        .onAppear(perform: viewModel.loadDashboardData)
    }
}

// DashboardViewModel.swift
class DashboardViewModel: ObservableObject {
    @Published var stats: DashboardStats
    @Published var projects: [Project]
    @Published var userQuota: UserQuota
    
    func loadDashboardData() { }
    func resetQuotaIfNeeded() { }
}
```

##### 文字生成模块
```swift
// TextGenerationView.swift
struct TextGenerationView: View {
    @StateObject var viewModel: TextGenerationViewModel
    @FocusState var isInputFocused: Bool
    
    var body: some View {
        VStack {
            TextInputArea()
            GenerationControls()
            ProgressIndicator()
        }
    }
}

// TextGenerationViewModel.swift
class TextGenerationViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var isGenerating: Bool = false
    @Published var generatedText: String = ""
    @Published var progress: Double = 0.0
    
    let textGenerationUseCase: TextGenerationUseCase
    
    func generateContent() async { }
    func stopGeneration() { }
    func saveResult() { }
}
```

### 6.3 依赖注入设计
```swift
// DIContainer.swift
class DIContainer {
    static let shared = DIContainer()
    
    private let swiftDataStorage: SwiftDataStorage
    private let userDefaultsStorage: UserDefaultsStorage
    
    // AI服务
    private let foundationModelsService: FoundationModelsService
    private let imagePlaygroundService: ImagePlaygroundService
    
    // 业务用例
    private let textGenerationUseCase: TextGenerationUseCase
    private let imageGenerationUseCase: ImageGenerationUseCase
    
    private init() {
        // 初始化依赖
    }
    
    func resolve<T>() -> T { }
}
```

### 6.4 测试策略
- **单元测试**：覆盖所有UseCase和核心业务逻辑
- **集成测试**：测试SwiftData存储和AI服务集成
- **UI测试**：关键用户流程自动化测试
- **性能测试**：AI生成性能和内存使用监控


