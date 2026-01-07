<template>
  <div class="common-layout">
    <el-container class="full-height">
      <el-aside width="240px" class="aside-container2"></el-aside>
      
      <el-aside width="240px" class="aside-container">
        <div class="logo">
          <img src="./assets/vue.svg" class="logo-icon" />
          <span>诸葛天机V114.5</span>
        </div>

        <div class="menu-wrapper">
          <el-menu
            default-active="/dashboard"
            router
            class="custom-menu"
            :unique-opened="true"
          >
            <el-menu-item index="/dashboard" class="menu-item-card">
              <el-icon><HomeFilled /></el-icon>
              <span>管理中心</span>
              <el-icon class="arrow-right"><ArrowRight /></el-icon>
            </el-menu-item>

            <el-sub-menu index="data">
              <template #title>
                <el-icon><Lightning /></el-icon>
                <span>数据中心</span>
              </template>
              <el-menu-item index="/info-manage">情报管理</el-menu-item>
              <el-menu-item index="1-2">机构管理</el-menu-item>
            </el-sub-menu>

            <el-sub-menu index="settings">
              <template #title>
                <el-icon><Operation /></el-icon>
                <span>设置中心</span>
              </template>
              <el-menu-item index="/model-settings">模型设置</el-menu-item>
              <el-menu-item index="2-2">用户设置</el-menu-item>
              <el-menu-item index="2-3">安全设置</el-menu-item>
            </el-sub-menu>
          </el-menu>
        </div>

        <div class="user-profile">
          <el-popover
            placement="top-start"
            :width="260"
            trigger="hover"
            popper-class="user-popover-custom"
            :offset="12"
          >
            <template #reference>
              <div class="user-card">
                <el-avatar 
                  :size="36" 
                  src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" 
                  class="user-avatar"
                />
                <span class="user-name">管理员114514</span>
              </div>
            </template>
            
            <div class="popover-content">
              <el-button type="primary" class="vip-btn">开通会员</el-button>
              <div class="points-wrapper">
                <div class="points-circle">
                  <span class="currency-symbol">¥</span>
                </div>
                <span class="points-count">1919810积分</span>
              </div>
            </div>
          </el-popover>
        </div>
      </el-aside>

      <el-main class="main-content">
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { HomeFilled, Lightning, Operation, ArrowRight } from '@element-plus/icons-vue'
</script>

<style>
/* 核心修复：消除浏览器默认边距导致的 100vh 溢出 */
html, body {
  margin: 0;
  padding: 0;
  height: 100%;
  overflow: hidden;
}

/* 弹窗样式需要写在非 scoped 或使用 deep，这里为了确保效果直接处理 */
.user-popover-custom {
  padding: 16px !important;
  border-radius: 12px !important;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1) !important;
}
</style>

<style scoped>
/* 容器基础样式 */
.common-layout {
  height: 100vh;
  width: 100vw;
  overflow: hidden;
}

.full-height {
  height: 100% !important;
}

.aside-container {
  background-color: #fff;
  border-right: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  position: fixed;
  height: 100vh;
  z-index: 10;
}

.aside-container2 {
  background-color: #fff;
  border-right: 1px solid #f0f0f0;
  height: 100vh;
  flex-shrink: 0;
}

/* 菜单包裹层：自动撑开并在内部滚动 */
.menu-wrapper {
  flex: 1;
  overflow-x: hidden;
  overflow-y: auto;
}

/* 隐藏滚动条美化 */
.menu-wrapper::-webkit-scrollbar {
  width: 4px;
}
.menu-wrapper::-webkit-scrollbar-thumb {
  background: #dbdbdb;
  border-radius: 10px;
}

/* 底部用户信息容器 */
.user-profile {
  padding: 16px 12px;
  border-top: 1px solid #f0f0f0;
  background-color: #fff;
}

.user-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px 12px;
  cursor: pointer;
  transition: all 0.3s ease;
  border-radius: 8px; /* 修改为8px更协调 */
}

.user-card:hover {
  background-color: #f5f7fa;
}

.user-avatar {
  flex-shrink: 0;
  border: 1px solid #eee;
}

.user-name {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: 500;
}

.logo {
  padding: 24px 20px;
  font-size: 20px;
  font-weight: bold;
  display: flex;
  align-items: center;
  gap: 10px;
  color: #303133;
}

.logo-icon {
  width: 32px;
  background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
  border-radius: 8px;
  padding: 4px;
}

:deep(.el-menu-item),
:deep(.el-sub-menu__title) {
  height: 50px !important;
  line-height: 50px !important;
  margin: 4px 12px !important; 
  width: calc(100% - 24px) !important; 
  border-radius: 8px !important;
  display: flex !important;
  align-items: center !important;
  transition: all 0.3s ease;
  padding: 0 16px !important; 
}

:deep(.el-menu-item span),
:deep(.el-sub-menu__title span) {
  flex: 1;
}

:deep(.el-sub-menu__icon-arrow) {
  position: static !important;
  margin: 0 !important;
  font-size: 14px !important;
  color: inherit !important;
}

.arrow-right {
  margin-right: 2px !important;
  font-size: 14px !important;
}

:deep(.el-icon) {
  font-size: 20px;
  margin-right: 10px;
  flex-shrink: 0;
}

:deep(.el-menu-item:hover),
:deep(.el-sub-menu__title:hover) {
  background-color: #f5f7fa !important;
  color: #409eff !important;
}

:deep(.el-menu-item.is-active) {
  background-color: #e6f4ff !important;
  color: #1890ff !important;
  font-weight: bold;
}

.custom-menu {
  border-right: none;
}

.main-content {
  background-color: #f5f7fa;
  height: 100vh;
  overflow-y: auto;
  padding: 20px;
}

/* 弹出层内容样式还原图片 */
.popover-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.vip-btn {
  background: #1890ff !important;
  border: none !important;
  padding: 8px 18px !important;
  height: 36px !important;
  font-size: 14px !important;
}

.points-wrapper {
  display: flex;
  align-items: center;
  gap: 8px;
}

.points-circle {
  width: 22px;
  height: 22px;
  border: 1.5px solid #666;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.currency-symbol {
  color: #1890ff;
  font-size: 14px;
  font-weight: bold;
}

.points-count {
  font-size: 16px;
  color: #303133;
  font-weight: 500;
}
</style>