import type {ReactNode} from 'react';
import Link from '@docusaurus/Link';
import useDocusaurusContext from '@docusaurus/useDocusaurusContext';
import Layout from '@theme/Layout';
import Heading from '@theme/Heading';

import styles from './index.module.css';

const stats = [
  {value: '12', label: '单细胞实践模块'},
  {value: '6', label: '组学实践专栏'},
  {value: '5', label: '可下载完整脚本'},
];

const modules = [
  ['01', '实践数据集与数据获取', '/docs/modules/module01'],
  ['02', '原始数据处理', '/docs/modules/module02'],
  ['03', '质控、聚类与注释', '/docs/modules/module03'],
  ['04', '多样本整合', '/docs/modules/module04'],
  ['05', '拟时序分析', '/docs/modules/module05'],
  ['06', '细胞通讯分析', '/docs/modules/module06'],
];

const columns = [
  ['Single-cell', '单细胞实践教程', '/docs/modules/module01'],
  ['RNA-seq', 'bulk RNA-seq 实践教程', '/docs/bulk-rnaseq/overview'],
  ['Genome', '基因组学实践教程', '/docs/genomics/overview'],
  ['Epigenome', '表观组学实践教程', '/docs/epigenomics/overview'],
  ['Proteome', '蛋白质组学实践教程', '/docs/proteomics/overview'],
  ['Integration', '多组学整合实践教程', '/docs/integration/overview'],
];

const tracks = [
  {
    title: '先建立分析环境',
    body: '先确定测试数据、下载方式和本地目录，让后续每一步分析都有可复现输入。',
  },
  {
    title: '再完成标准流程',
    body: '围绕 Seurat 工作流学习质控、归一化、降维、聚类、注释和差异分析。',
  },
  {
    title: '最后进入专题应用',
    body: '继续学习数据整合、轨迹推断、细胞通讯、多模态、空间转录组和 scATAC-seq。',
  },
];

const workflow = ['数据获取', '质量控制', '降维聚类', '细胞注释', '功能解释'];

function HomeHero() {
  return (
    <header className={styles.hero}>
      <div className={styles.heroInner}>
        <div className={styles.heroCopy}>
          <p className={styles.eyebrow}>BioF3 Omics Tutorial</p>
          <Heading as="h1" className={styles.heroTitle}>
            面向实践的生物组学数据分析教程
          </Heading>
          <p className={styles.heroText}>
            BioF3 将单细胞与多组学分析拆解成可阅读、可运行、可复现的学习单元，
            帮助学习者从基础环境搭建走到完整分析流程。
          </p>
          <div className={styles.actions}>
            <Link className="button button--primary button--lg" to="/docs/intro">
              开始学习
            </Link>
            <Link className="button button--secondary button--lg" to="/docs/modules/module01">
              下载实践数据
            </Link>
            <Link className="button button--secondary button--lg" to="/docs/modules/module03">
              查看分析流程
            </Link>
          </div>

          <div className={styles.heroSummary} aria-label="BioF3 course overview">
            <div className={styles.summaryHeader}>
              <span>当前重点课程</span>
              <strong>scRNA-seq</strong>
            </div>
            <div className={styles.workflow}>
              {workflow.map((item) => (
                <span key={item}>{item}</span>
              ))}
            </div>
            <div className={styles.metrics}>
              {stats.map((item) => (
                <div key={item.label}>
                  <strong>{item.value}</strong>
                  <span>{item.label}</span>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </header>
  );
}

function LearningTracks() {
  return (
    <section className={styles.section}>
      <div className={styles.sectionHeader}>
        <p className={styles.eyebrow}>Learning Path</p>
        <Heading as="h2">按真实分析顺序组织课程</Heading>
      </div>
      <div className={styles.trackGrid}>
        {tracks.map((track, index) => (
          <article className={styles.trackCard} key={track.title}>
            <span className={styles.trackIndex}>{String(index + 1).padStart(2, '0')}</span>
            <Heading as="h3">{track.title}</Heading>
            <p>{track.body}</p>
          </article>
        ))}
      </div>
    </section>
  );
}

function ModuleStart() {
  return (
    <section className={styles.section}>
      <div className={styles.sectionHeader}>
        <p className={styles.eyebrow}>Core Modules</p>
        <Heading as="h2">从这些模块开始动手</Heading>
      </div>
      <div className={styles.moduleGrid}>
        {modules.map(([number, title, href]) => (
          <Link className={styles.moduleItem} to={href} key={number}>
            <span>{number}</span>
            <strong>{title}</strong>
          </Link>
        ))}
      </div>
    </section>
  );
}

function OmicsColumns() {
  return (
    <section className={styles.section}>
      <div className={styles.sectionHeader}>
        <p className={styles.eyebrow}>Omics Columns</p>
        <Heading as="h2">按组学方向组织实践专栏</Heading>
      </div>
      <div className={styles.moduleGrid}>
        {columns.map(([label, title, href]) => (
          <Link className={styles.moduleItem} to={href} key={label}>
            <span>{label}</span>
            <strong>{title}</strong>
          </Link>
        ))}
      </div>
    </section>
  );
}

function PracticeBlock() {
  return (
    <section className={styles.practice}>
      <div>
        <p className={styles.eyebrow}>Reproducible Practice</p>
        <Heading as="h2">教程、图示和完整脚本放在同一条学习线上</Heading>
        <p>
          多个模块已经配套可下载 R 脚本和结果图，实践数据集页面提供 PBMC 3k、
          CITE-seq、Visium 和 scATAC 的真实测试数据入口，适合边读教程边复现。
          后续模块会继续按同一标准补齐实践材料。
        </p>
      </div>
      <Link className="button button--primary" to="/docs/modules/module01">
        查看实践数据集
      </Link>
    </section>
  );
}

export default function Home(): ReactNode {
  const {siteConfig} = useDocusaurusContext();

  return (
    <Layout
      title={siteConfig.title}
      description="BioF3 - 从基础到进阶的生物组学数据分析实践教程">
      <HomeHero />
      <main>
        <LearningTracks />
        <ModuleStart />
        <OmicsColumns />
        <PracticeBlock />
      </main>
    </Layout>
  );
}
