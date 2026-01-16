<template>
  <component is="style">
    @import url('https://app.windfonts.com/api/css?family=wenfeng-ysbth:wght@bold');
  </component>

  <div class="page-container">
    <div class="header-section">
      <h2 class="sub-title wf-font-ysbth-bold">全球科技布局，战略规划，资助动向，政策信息，</h2>
      <h1 class="main-title wf-font-ysbth-bold">一键直达</h1>
    </div>

    <div class="search-wrapper">
      <div class="gradient-border-box">
        <div class="search-content">
          <input 
            type="text" 
            placeholder="输入关键词，支持段落级语义检索，描述越详细，检索越精准" 
            class="custom-input"
            v-model="searchQuery"
            @keyup.enter="handleSearch"
          />
          
          <div class="action-group" @click="handleSearch">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-send-fill send-icon" viewBox="0 0 16 16">
 <path d="M15.964.686a.5.5 0 0 0-.65-.65L.767 5.855H.766l-.452.18a.5.5 0 0 0-.082.887l.41.26.001.002 4.995 3.178 3.178 4.995.002.002.26.41a.5.5 0 0 0 .886-.083zm-1.833 1.89L6.637 10.07l-.215-.338a.5.5 0 0 0-.154-.154l-.338-.215 7.494-7.494 1.178-.471z"/>
</svg>
            
            <div class="switch-container">
              <el-switch
                v-model="isGlobalSearch"
                active-color="#00e676"
                inactive-color="#dcdfe6"
              />
              <span class="switch-label">全网检索</span>
            </div>
          </div>
        </div>
      </div>
      <el-icon class="settings-icon"><Operation /></el-icon>
    </div>

    <div class="hot-search-container">
      <span class="hot-search-item" @click="handleHotSearch('搜索内容1')">搜索内容1</span>
      <span class="divider">|</span>
      <span class="hot-search-item" @click="handleHotSearch('搜索内容2')">搜索内容2</span>
      <span class="divider">|</span>
      <span class="hot-search-item" @click="handleHotSearch('搜索内容3')">搜索内容3</span>
      <span class="divider">|</span>
      <span class="hot-search-item" @click="handleHotSearch('搜索内容4')">搜索内容4</span>
    </div>

    <div class="cards-container">
      <div class="feature-card bg-cyan">
        <div class="card-title">AI智能研判</div>
        <div class="card-desc">AI智能研判，检索符合基金委需求的近期情报</div>
      </div>

      <div class="feature-card bg-blue">
        <div class="card-header">
          <div class="card-title">按机构检索</div>
          <el-icon class="card-icon"><School /></el-icon>
        </div>
        <div class="card-desc">给定目标机构，AI一键智能抓取近期关键情报</div>
      </div>

      <div class="feature-card bg-teal">
        <div class="badge">NEW</div>
        <div class="card-header">
          <div class="card-title">按领域检索</div>
          <el-icon class="card-icon"><Grid /></el-icon>
        </div>
        <div class="card-desc">给定领域，AI智能分析挖掘领域关键情报</div>
      </div>

      <div class="feature-card bg-purple">
        <div class="badge">NEW</div>
        <div class="card-header">
          <div class="card-title">按时间检索</div>
          <el-icon class="card-icon"><Document /></el-icon>
        </div>
        <div class="card-desc">给定时间范围，AI智能分析近期全球范围关键情报</div>
      </div>

      <div class="feature-card bg-light-blue">
        <div class="card-header">
          <div class="card-title">更多功能</div>
          <el-icon class="card-icon blue-plus"><CirclePlus /></el-icon>
        </div>
        <div class="card-desc">正在开发，敬请期待...</div>
      </div>
    </div>

<div style="position:relative:width:100%;height:40px;"></div>
    <!-- 新增的情报卡片 -->
    <div class="intelligence-card">
      <div class="tab-header">
        <div 
          v-for="(tab, index) in tabs" 
          :key="index" 
          :class="['tab-item', { 'active': activeTab === index }]"
          @click="activeTab = index"
        >
          {{ tab }}
          <div v-if="activeTab === index" class="underline"></div>
        </div>
      </div>
      
      <div class="card-content">
        <div class="card-title">{{ tabs[activeTab] }}</div>
        <div class="items-grid">
          <div 
            v-for="(item, idx) in intelligenceData[activeTab]" 
            :key="idx" 
            class="intelligence-item"
            @click="removeItem(activeTab, idx)"
          >
            <div class="item-title">{{ item.title }}</div>
            <div class="item-desc">{{ truncateText(item.description) }}</div>
          </div>
        </div>
        <div class="more-link">更多</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router' // 引入路由
// 补充了卡片所需的图标
import { Promotion, Operation, School, Cpu, Document, CirclePlus ,Grid ,Right} from '@element-plus/icons-vue'

const router = useRouter()
const searchQuery = ref('') // 绑定输入框内容
const isGlobalSearch = ref(true)

// 执行搜索跳转
const handleSearch = () => {
  if (!searchQuery.value.trim()) return
  
  router.push({
    path: '/search', // 假设你的路由路径是 /search
    query: { 
      keyword: searchQuery.value,
      global: isGlobalSearch.value 
    }
  })
}

// 处理热搜点击
const handleHotSearch = (text) => {
  searchQuery.value = text
  handleSearch()
}

// 情报数据
const tabs = ref(['近期情报', '热点情报', '高分情报', '精选情报'])
const activeTab = ref(0)

const intelligenceData = ref([
  [
    { title: '特朗普签署创世纪计划', description: '特朗普政府宣布启动创世纪计划，旨在推动美国在太空探索领域的领先地位，计划投资500亿美元用于月球和火星探索项目，预计将在未来十年内实现载人火星登陆。该计划还包括建立月球基地和开发新型推进技术。' },
    { title: '英国发布2026年研发预算', description: '英国政府公布2026年度研发预算，总额达200亿英镑，重点支持人工智能、量子计算和生物技术领域。预算将用于支持大学研究项目、企业创新和国际合作。' },
    { title: '英国发布人工智能战略', description: '英国政府发布全新人工智能发展战略，计划在未来五年内投资150亿英镑，用于AI基础设施建设、人才培养和产业应用。该战略旨在使英国成为全球AI创新中心。' },
    { title: '德国与美国签科研合作', description: '德国与美国签署了一项重要的科研合作协议，双方将在清洁能源、生物技术和先进制造领域展开深入合作。协议包括研究人员交流、联合实验室建设和项目资金支持。' },
    { title: '英国发布研究创新预算分配', description: '英国研究与创新署公布了2026年预算分配方案，总预算达到300亿英镑，用于支持各领域的科学研究和技术创新。重点资助项目包括气候变化研究、数字技术发展和健康科学。' },
    { title: '日本通过4000亿日元预算', description: '日本国会通过了4000亿日元的科技研发预算，主要用于支持人工智能、半导体和量子技术发展。预算将用于加强国内科研能力、吸引国际人才和推动产业创新。' }
  ],
  [
    { title: '欧盟发布量子技术路线图', description: '欧盟委员会发布了量子技术发展路线图，计划在未来十年内投资1000亿欧元，用于量子计算、量子通信和量子传感技术的研发。该路线图旨在确保欧盟在量子技术领域的全球竞争力。' },
    { title: '中国启动新一代人工智能计划', description: '中国政府启动新一代人工智能发展计划，计划投资1000亿人民币，重点发展自主可控的AI核心技术。计划包括建设国家AI实验室、培养高端人才和推动AI在各行业的应用。' },
    { title: '印度推出国家半导体计划', description: '印度政府宣布启动国家半导体计划，计划投资7600亿卢比，用于建设半导体制造工厂和研发设施。该计划旨在减少对进口芯片的依赖，提升本土半导体产业能力。' },
    { title: '加拿大增加清洁能源投资', description: '加拿大政府宣布增加清洁能源领域投资，计划在未来五年内投资500亿加元，用于支持风能、太阳能和氢能技术发展。投资将用于基础设施建设、技术研发和市场推广。' },
    { title: '澳大利亚扩大太空探索预算', description: '澳大利亚航天局宣布扩大太空探索预算，新增投资200亿澳元，用于支持月球探测、卫星技术和深空探索项目。预算将用于与国际伙伴合作开发新型航天器和探测设备。' },
    { title: '韩国公布半导体产业扶持政策', description: '韩国政府公布半导体产业扶持政策，计划投资500万亿韩元，用于支持芯片制造、材料研发和人才培养。政策旨在巩固韩国在全球半导体市场的领先地位。' }
  ],
  [
    { title: 'MIT发布颠覆性科技报告', description: '麻省理工学院发布年度颠覆性科技报告，列出了未来十年最具潜力的十大技术突破，包括量子计算、生物计算、神经形态芯片等。报告分析了这些技术的商业化前景和社会影响。' },
    { title: '斯坦福AI实验室突破', description: '斯坦福大学AI实验室在自然语言处理领域取得重大突破，开发出新一代语言模型，具有更强的理解和生成能力。该模型在多个基准测试中表现优异，有望推动AI技术的进一步发展。' },
    { title: '剑桥发布生物技术白皮书', description: '剑桥大学发布生物技术发展白皮书，详细分析了基因编辑、合成生物学和细胞治疗等前沿技术的发展趋势。白皮书提出了未来十年的研究重点和产业化路径。' },
    { title: '牛津量子计算新进展', description: '牛津大学量子计算研究中心在量子纠错技术方面取得重要进展，成功实现了1000个量子比特的稳定纠错。这一突破为实用化量子计算机的实现奠定了重要基础。' },
    { title: '加州理工空间探测突破', description: '加州理工学院的科学家在空间探测技术方面取得突破，开发出新型深空探测器，能够到达太阳系边缘进行科学探测。探测器采用了先进的推进技术和能源系统。' },
    { title: '东京大学新材料发现', description: '东京大学研究团队发现了一种具有革命性潜力的新材料，该材料具有超导、高强度和轻质等特性。这一发现有望在航空航天、能源和电子等领域带来重大变革。' }
  ],
  [
    { title: '诺贝尔奖得主联合倡议', description: '多位诺贝尔奖得主联合发起科学倡议，呼吁全球加强基础科学研究投入，推动解决气候变化、疾病治疗和能源危机等重大挑战。倡议提出了国际合作的具体方案和资金支持机制。' },
    { title: '联合国可持续发展目标进展', description: '联合国发布可持续发展目标科技支撑报告，分析了科技创新在实现可持续发展目标中的重要作用。报告提出了利用技术手段加速目标实现的具体路径和政策措施。' },
    { title: '世界银行科技投资报告', description: '世界银行发布全球科技投资报告，分析了各国科技投资趋势和效果。报告显示，科技投资对经济增长和社会发展具有重要推动作用，建议增加对发展中国家的科技支持。' },
    { title: '国际能源署最新预测', description: '国际能源署发布全球能源技术发展预测报告，预测未来二十年清洁能源技术将实现重大突破。报告分析了太阳能、风能、储能和氢能技术的发展前景和投资机会。' },
    { title: '世界经济论坛科技趋势', description: '世界经济论坛发布年度科技趋势报告，识别了将影响全球经济和社会的十大关键技术趋势。报告涵盖了人工智能、生物技术、材料科学和量子技术等领域的发展前景。' },
    { title: 'OECD科技创新评估', description: 'OECD发布成员国科技创新能力评估报告，比较分析了各国在研发投入、人才储备、产业应用等方面的差异。报告为各国制定科技政策提供了重要参考。' }
  ]
])

// 删除情报项
const removeItem = (tabIndex, itemIndex) => {
  intelligenceData.value[tabIndex].splice(itemIndex, 1)
}

// 截断文本函数
const truncateText = (text, maxLength = 30) => {
  if (!text) return ''
  if (text.length <= maxLength) return text
  return text.substring(0, maxLength) + '...'
}
</script>

<style scoped>
/* 严格按照你的样式要求进行定义 */
.wf-font-ysbth-bold {
    font-family: 'wenfeng-ysbth';
    font-style: normal;
    font-weight:200 !important;
}

.page-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 40px;
  background-color: transparent;
}

.header-section {
  text-align: center;
  margin-bottom: 40px;
}

.sub-title {
  font-size: 24px;
  color: #2c3e50;
  letter-spacing: 2px;
  margin-bottom: 15px;
}

.main-title {
  font-size: 56px;
  color: #1a237e;
  letter-spacing: 4px;
  margin: 0;
}

.search-wrapper {
  display: flex;
  align-items: center;
  width: 100%;
  max-width: 900px;
  gap: 15px;
  margin-bottom: 12px; /* 减小底部间距，为热搜留出空间 */
}

.gradient-border-box {
  flex: 1;
  padding: 2px;
  border-radius: 12px;
  background: linear-gradient(to right, #90caf9, #f48fb1, #ffab91);
  position: relative;
}

.search-content {
  background: #fff;
  border-radius: 10px;
  display: flex;
  align-items: center;
  padding: 10px 20px;
}

.custom-input {
  flex: 1;
  border: none;
  outline: none;
  font-size: 16px;
  color: #606266;
  padding: 8px 0;
}

.custom-input::placeholder {
  color: #909399;
  font-size: 14px;
}

.action-group {
  display: flex;
  align-items: center;
  gap: 15px;
  border-left: 1px solid #f0f0f0;
  padding-left: 15px;
}

.send-icon {
  color: #3f51b5;
  cursor: pointer;
  transform: rotate(45deg) scale(1.4);
}

.switch-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.switch-label {
  font-size: 12px;
  color: #333;
  font-weight: bold;
}

.settings-icon {
  font-size: 28px;
  color: #333;
  cursor: pointer;
}

/* 热搜样式 */
.hot-search-container {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  margin-bottom: 48px; /* 保持与下方卡片的距离 */
  font-size: 14px;
  color: #666;
}

.hot-search-item {
  cursor: pointer;
  transition: color 0.2s;
}

.hot-search-item:hover {
  color: #3f51b5;
}

.divider {
  color: #dcdfe6;
  user-select: none;
}

:deep(.el-switch.is-checked .el-switch__core) {
  background-color: #00e676 !important;
}

/* --- 卡片样式 --- */
.cards-container {
  display: flex;
  gap: 20px;
  width: 100%;
  max-width: 1100px;
  justify-content: center;
  margin-top: 20px;
}

.feature-card {
  flex: 1;
  min-height: 120px;
  border-radius: 16px;
  padding: 20px;
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  transition: transform 0.2s;
  cursor: pointer;
}

.feature-card:hover {
  transform: translateY(-5px);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 10px;
}

.card-title {
  font-size: 18px;
  font-weight: bold;
  color: #333;
}

.card-desc {
  font-size: 12px;
  color: #666;
  line-height: 1.5;
}

.card-icon {
  font-size: 24px;
  color: #90a4ae;
}

.blue-plus {
  color: #409eff;
}

.bg-cyan { background: linear-gradient(135deg, #e0f7fa 0%, #f4fdfe 100%); }
.bg-blue { background: linear-gradient(135deg, #e8eaf6 0%, #f5f6fb 100%); }
.bg-teal { background: linear-gradient(135deg, #e0f2f1 0%, #f2faf9 100%); }
.bg-purple { background: linear-gradient(135deg, #f3e5f5 0%, #fbf7fd 100%); }
.bg-light-blue { background: linear-gradient(135deg, #ebf3ff 0%, #f7faff 100%); }

.badge {
  position: absolute;
  top: -10px;
  right: 10px;
  background-color: #ff5252;
  color: white;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 4px;
  font-weight: bold;
}

/* --- 新增的情报卡片样式 --- */
.intelligence-card {
  width: 100%;
  max-width: 1100px;
  background: #fff;
  border-radius: 16px;
  padding: 20px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
  margin-top: 20px;
}

.tab-header {
  display: flex;
  gap: 24px;
  margin-bottom: 16px;
  border-bottom: 1px solid #e0e0e0;
  padding-bottom: 12px;
}

.tab-item {
  font-size: 14px;
  color: #666;
  cursor: pointer;
  padding: 8px 0;
  position: relative;
  transition: color 0.2s;
}

.tab-item:hover {
  color: #333;
}

.tab-item.active {
  color: #333;
  font-weight: bold;
}

.tab-item.active .underline {
  position: absolute;
  bottom: -12px;
  left: 0;
  right: 0;
  height: 3px;
  background-color: #3f51b5;
  border-radius: 1.5px;
}

.card-content {
  position: relative;
}

.card-title {
  font-size: 16px;
  font-weight: bold;
  color: #333;
  margin-bottom: 16px;
}

.items-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 16px;
  margin-bottom: 16px;
}

.intelligence-item {
  background: #f0f5ff;
  border-radius: 8px;
  padding: 12px 16px;
  cursor: pointer;
  transition: all 0.2s;
}

.intelligence-item:hover {
  background: #e0ecff;
  transform: translateY(-2px);
}

.item-title {
  font-size: 14px;
  color: #333;
  font-weight: bold;
  margin-bottom: 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.item-desc {
  font-size: 12px;
  color: #666;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
}

.more-link {
  position: absolute;
  top: 0;
  right: 0;
  font-size: 12px;
  color: #666;
  cursor: pointer;
  padding: 8px 12px;
}

.more-link:hover {
  color: #3f51b5;
}
</style>