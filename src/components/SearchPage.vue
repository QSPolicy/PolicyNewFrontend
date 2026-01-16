<template>
  <div class="search-page-container">
    <div class="filter-bar">
      <el-input v-model="searchKeyword" placeholder="标题包含" style="width: 200px" />
      <el-input placeholder="主题包含" style="width: 200px" />
      <el-select placeholder="机构包含" style="width: 200px"></el-select>
      <el-button type="primary" @click="fetchResults">筛选</el-button>
    </div>

    <div class="main-content">
      <aside class="side-filter">
        <div class="filter-group">
          <h4>发布年份</h4>
          <el-checkbox-group v-model="selectedYears">
            <el-checkbox label="2025-2026" />
            <el-checkbox label="2020-2024" />
            <el-checkbox label="2015-2019" />
            <el-checkbox label="2010-2014" />
            <el-checkbox label="2010以前" />
          </el-checkbox-group>
        </div>
        <div class="filter-group" style="margin-top: 20px;">
          <h4>时效性</h4>
          <el-checkbox-group v-model="selectedStatus">
            <el-checkbox label="尚未生效" />
            <el-checkbox label="有效" />
            <el-checkbox label="已修改" />
            <el-checkbox label="已废止" />
          </el-checkbox-group>
        </div>
      </aside>

      <main class="results-list">
        <div class="list-controls">
          <el-checkbox 
            v-model="isAllSelected" 
            :indeterminate="isIndeterminate"
            @change="handleSelectAll"
          >
            已选{{ selectedIds.length }}条
          </el-checkbox>
          <el-button size="small" style="margin-left: 10px;">批量处理</el-button>
          <el-select placeholder="排序方式" size="small" style="width: 120px; margin-left: 10px;"></el-select>
          <div style="flex: 1"></div>
          <el-switch v-model="onlyPdf" active-text="只看PDF" />
          <el-button type="primary" size="small" style="margin-left: 20px;">更多操作</el-button>
        </div>

        <div v-for="item in pagedResults" :key="item.id" class="result-card">
          <div class="card-header" style="display: flex; align-items: center;">
            <el-checkbox 
              :model-value="selectedIds.includes(item.id)" 
              @change="(val) => handleSelectChange(val, item.id)"
            />
            <h3 class="result-title" v-html="highlight(item.title)"></h3>
            <div class="icons" style="margin-left: auto; display: flex; align-items: center; gap: 12px;">
              <el-icon color="#f56c6c"><Document /></el-icon>
              
              <el-icon 
                :color="item.isLiked ? '#409eff' : '#999'" 
                style="cursor: pointer;" 
                @click="toggleLike(item)"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-hand-thumbs-up" viewBox="0 0 16 16">
                  <path d="M8.864.046C7.908-.193 7.02.53 6.956 1.466c-.072 1.051-.23 2.016-.428 2.59-.125.36-.479 1.013-1.04 1.639-.557.623-1.282 1.178-2.131 1.41C2.685 7.288 2 7.87 2 8.72v4.001c0 .845.682 1.464 1.448 1.545 1.07.114 1.564.415 2.068.723l.048.03c.272.165.578.348.97.484.397.136.861.217 1.466.217h3.5c.937 0 1.599-.477 1.934-1.064a1.86 1.86 0 0 0 .254-.912c0-.152-.023-.312-.077-.464.201-.263.38-.578.488-.901.11-.33.172-.762.004-1.149.069-.13.12-.269.159-.403.077-.27.113-.568.113-.857 0-.288-.036-.585-.113-.856a2.144 2.144 0 0 0-.138-.362 1.9 1.9 0 0 0 .234-1.734c-.206-.592-.682-1.1-1.2-1.272-.847-.282-1.803-.276-2.516-.211a9.84 9.84 0 0 0-.443.05 9.365 9.365 0 0 0-.062-4.509A1.38 1.38 0 0 0 9.125.111L8.864.046zM11.5 14.721H8c-.51 0-.863-.069-1.14-.164-.281-.097-.506-.228-.776-.393l-.04-.024c-.555-.339-1.198-.731-2.49-.868-.333-.036-.554-.29-.554-.55V8.72c0-.254.226-.543.62-.65 1.095-.3 1.977-.996 2.614-1.708.635-.71 1.064-1.475 1.238-1.978.243-.7.407-1.768.482-2.85.025-.362.36-.594.667-.518l.262.066c.16.04.258.143.288.255a8.34 8.34 0 0 1-.145 4.725.5.5 0 0 0 .595.644l.003-.001.014-.003.058-.014a8.908 8.908 0 0 1 1.036-.157c.663-.06 1.457-.054 2.11.164.175.058.45.3.57.65.107.308.087.67-.266 1.022l-.353.353.353.354c.043.043.105.141.154.315.048.167.075.37.075.581 0 .212-.027.414-.075.582-.05.174-.111.272-.154.315l-.353.353.353.354c.047.047.109.177.005.488a2.224 2.224 0 0 1-.505.805l-.353.353.353.354c.006.005.041.05.041.17a.866.866 0 0 1-.121.416c-.165.288-.503.56-1.066.56z"/>
                </svg>
              </el-icon>

              <el-icon 
                :color="item.isFavorite ? '#f56c6c' : '#999'" 
                style="cursor: pointer;"
                @click="toggleFavorite(item)"
              >
                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart" viewBox="0 0 16 16">
                  <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01L8 2.748zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143c.06.055.119.112.176.171a3.12 3.12 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15z"/>
                </svg>
              </el-icon>
            </div>
          </div>
          
          <div class="meta-info">
            <span>来源机构：{{ item.source }}</span>
            <span>发布日期：{{ item.date }}</span>
            <span>下载量：{{ item.downloads }}</span>
            <span style="display: flex; align-items: center; transform:translateY(-8px);">评分：<el-rate v-model="item.rating" disabled /></span>
          </div>

          <p class="summary">
            <span v-html="highlight(item.summary)"></span>
            <span class="more">【展开更多】</span>
          </p>

          <div class="tags">
            关键词：
            <el-tag v-for="tag in item.tags" :key="tag" size="small" style="margin-right: 5px;">
              <span v-html="highlight(tag)"></span>
            </el-tag>
          </div>

          <div class="card-actions" style="margin-top: 15px; border-top: 1px dashed #eee; padding-top: 10px; display: flex; align-items: center;">
            <el-button link :icon="Reading">在线阅读</el-button>
            <el-button link :icon="Download">下载PDF</el-button>
             <div style="display: flex; align-items: center; margin-right: 20px;">
              <span style="font-size: 13px; color: #606266;padding-left:15px; margin-right: 8px;">存入情报空间</span>
              <el-switch v-model="item.isInSpace" size="small" />
            </div>
            <div style="flex: 1"></div>

            <el-button link type="danger" :icon="Delete" @click="deleteItem(item.id)">删除该情报</el-button>
          </div>
        </div>

        <div class="pagination-container" style="margin-top: 20px; display: flex; justify-content: flex-end;">
          <el-pagination
            v-model:current-page="currentPage"
            v-model:page-size="pageSize"
            layout="total, prev, pager, next, jumper"
            :total="results.length"
          />
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'
import { Reading, Download, Delete, Star, Share, Document, InfoFilled } from '@element-plus/icons-vue'
import { ElMessageBox, ElMessage } from 'element-plus'

const route = useRoute()
const searchKeyword = ref('')
const selectedYears = ref(['2025-2026'])
const selectedStatus = ref([])
const onlyPdf = ref(true)
const currentPage = ref(1)
const pageSize = ref(16) 
const results = ref([])

// 选中项 ID 列表
const selectedIds = ref([])

// 全选状态计算
const isAllSelected = computed(() => {
  return results.value.length > 0 && selectedIds.value.length === results.value.length
})

// 半选状态计算
const isIndeterminate = computed(() => {
  return selectedIds.value.length > 0 && selectedIds.value.length < results.value.length
})

// 处理全选/取消全选
const handleSelectAll = (val) => {
  selectedIds.value = val ? results.value.map(item => item.id) : []
}

// 处理单选
const handleSelectChange = (val, id) => {
  if (val) {
    selectedIds.value.push(id)
  } else {
    selectedIds.value = selectedIds.value.filter(item => item !== id)
  }
}

// 高亮逻辑
const highlight = (text) => {
  if (!searchKeyword.value || !text) return text;
  const escapedKeyword = searchKeyword.value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const reg = new RegExp(escapedKeyword, 'gi');
  return text.replace(reg, (matched) => `<span style="color: red; font-weight: bold;">${matched}</span>`);
}

// 删除功能实现
const deleteItem = (id) => {
  ElMessageBox.confirm('确定要从数据库中彻底删除该情报吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(() => {
    results.value = results.value.filter(item => item.id !== id);
    // 同时移除选中状态
    selectedIds.value = selectedIds.value.filter(sid => sid !== id);
    ElMessage.success('删除成功');
  }).catch(() => {});
}

// 收藏切换逻辑
const toggleFavorite = (item) => {
  item.isFavorite = !item.isFavorite;
  ElMessage.info(item.isFavorite ? '已加入收藏' : '已取消收藏');
}

// 点赞切换逻辑
const toggleLike = (item) => {
  item.isLiked = !item.isLiked;
  ElMessage.success(item.isLiked ? '点赞成功' : '已取消点赞');
}

const pagedResults = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = start + pageSize.value
  return results.value.slice(start, end)
})

const generateDemoData = () => {
  const data = []
  const titles = [
    '英国研究与创新署公布《英国研究与创新预算分配》',
    '法国高等教育、研究与空间部与法国国家科研署签署2026-2030年目标与绩效合同',
    '德国科研界呼吁欧盟将整体科研预算增至2000亿欧元'
  ]
  
  for (let i = 1; i <= 20; i++) {
    data.push({
      id: i,
      title: `${titles[i % 3]} (测试数据 ${i})`,
      source: i % 2 === 0 ? '英国研究与创新署 (UKRI)' : '法国国家科研署 (ANR)',
      date: '2025年12月17日',
      downloads: Math.floor(Math.random() * 200),
      rating: 4,
      summary: '12月17日，相关机构发布了一份关于其2026至2030财年预算分配的详细报告...',
      tags: ['预算分配', '基础研究', '高增长领域', '成果导向'],
      isInSpace: false,
      isFavorite: false,
      isLiked: false
    })
  }
  results.value = data
}

onMounted(() => {
  generateDemoData()
  if (route.query.keyword) {
    searchKeyword.value = route.query.keyword
    fetchResults()
  }
})

const fetchResults = () => {
  currentPage.value = 1 
}
</script>

<style scoped>
.search-page-container {
 padding: 20px; 
 background: #f5f7fa;
  min-height: 100vh; 
 }
.filter-bar {
 background: #fff; 
 padding: 15px; 
 border-radius: 8px;
  display: flex;
   gap: 10px;
    align-items: center; 
 }
.main-content { 
display: flex;
 gap: 20px;
 margin-top: 20px;
 }
.side-filter {
 width: 220px;
  background: #fff; 
  padding: 15px;
   border-radius: 8px;
    height: fit-content; }
.filter-group h4 { margin-bottom: 15px; color: #333; border-bottom: 1px solid #eee; padding-bottom: 5px; }
.results-list { flex: 1; }
.list-controls { background: #fff; padding: 10px 20px; border-radius: 8px; margin-bottom: 15px; display: flex; align-items: center; }
.result-card { background: #fff; padding: 20px; margin-bottom: 15px; border-radius: 8px; border: 1px solid #e4e7ed; }
.result-title { color: #3f51b5; margin: 0 10px; font-size: 18px; flex: 1; }
.meta-info { font-size: 12px; color: #999; margin: 10px 0; display: flex; gap: 20px; }
.summary { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 10px; }
.more { color: #409eff; cursor: pointer; }
.tags { font-size: 13px; color: #333; }
</style>