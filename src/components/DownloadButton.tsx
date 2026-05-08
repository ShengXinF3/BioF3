import React from 'react';
import useBaseUrl from '@docusaurus/useBaseUrl';

interface DownloadButtonProps {
  fileUrl: string;
  fileName: string;
  fileSize?: string;
  children?: React.ReactNode;
}

const DownloadButton: React.FC<DownloadButtonProps> = ({ 
  fileUrl, 
  fileName, 
  fileSize,
  children 
}) => {
  const isExternalUrl = /^https?:\/\//.test(fileUrl);
  const baseUrlFileUrl = useBaseUrl(fileUrl);
  const resolvedFileUrl = isExternalUrl ? fileUrl : baseUrlFileUrl;

  const handleDownload = () => {
    // 创建一个隐藏的 a 标签来触发下载
    const link = document.createElement('a');
    link.href = resolvedFileUrl;
    link.download = fileName;
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <div style={{ margin: '20px 0' }}>
      <button
        onClick={handleDownload}
        style={{
          backgroundColor: '#2e8555',
          color: 'white',
          padding: '12px 24px',
          border: 'none',
          borderRadius: '6px',
          fontSize: '16px',
          cursor: 'pointer',
          fontWeight: 'bold',
          display: 'inline-flex',
          alignItems: 'center',
          gap: '8px',
          transition: 'all 0.3s ease',
        }}
        onMouseEnter={(e) => {
          e.currentTarget.style.backgroundColor = '#26734d';
          e.currentTarget.style.transform = 'translateY(-2px)';
          e.currentTarget.style.boxShadow = '0 4px 12px rgba(46, 133, 85, 0.3)';
        }}
        onMouseLeave={(e) => {
          e.currentTarget.style.backgroundColor = '#2e8555';
          e.currentTarget.style.transform = 'translateY(0)';
          e.currentTarget.style.boxShadow = 'none';
        }}
      >
        <span style={{ fontSize: '20px' }}>📥</span>
        {children || `下载 ${fileName}`}
      </button>
      {fileSize && (
        <span style={{ 
          marginLeft: '12px', 
          color: '#666',
          fontSize: '14px'
        }}>
          ({fileSize})
        </span>
      )}
    </div>
  );
};

export default DownloadButton;
