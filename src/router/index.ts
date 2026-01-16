import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/',
    redirect: '/dashboard',
    children: [
      { path: 'dashboard', component: () => import('../views/Dashboard.vue') },
      { path: 'info-manage', component: () => import('../views/InfoManage.vue') },
      { path: 'model-settings', component: () => import('../views/ModelSettings.vue') },
      { path: 'search', component: () => import('../components/SearchPage.vue') } 
    ]
  }
];

export const router = createRouter({
  history: createWebHistory(),
  routes
});