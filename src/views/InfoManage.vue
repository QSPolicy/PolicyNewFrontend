<template>
  <div class="page-container">
    <h2>情报管理</h2>
    <el-table :data="[]" style="width: 100%" border>
      <el-table-column prop="date" label="日期" />
      <el-table-column prop="title" label="情报标题" />
    </el-table>
  </div>
</template>