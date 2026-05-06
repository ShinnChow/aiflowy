/**
 * 文件类型枚举
 */
export enum FileType {
  EXCEL = 'excel',
  MARKDOWN = 'markdown',
  PDF = 'pdf',
  PPT = 'ppt',
  TXT = 'txt',
  UNKNOWN = 'unknown',
  WORD = 'word',
}

/**
 * 根据文件后缀名判断文件类型
 * @param fileName 文件名或文件路径
 * @returns 文件类型
 */
export function getFileType(fileName: string): FileType {
  if (!fileName) {
    return FileType.UNKNOWN;
  }

  // 提取文件后缀名并转为小写
  const lastDotIndex = fileName.lastIndexOf('.');
  if (lastDotIndex === -1 || lastDotIndex === fileName.length - 1) {
    return FileType.UNKNOWN;
  }

  const extension = fileName.slice(lastDotIndex + 1).toLowerCase();

  // Markdown 文件
  if (['markdown', 'md', 'mdown', 'mdwn', 'mkd', 'mkdn'].includes(extension)) {
    return FileType.MARKDOWN;
  }

  // 纯文本文件
  if (['asc', 'log', 'text', 'txt'].includes(extension)) {
    return FileType.TXT;
  }

  // Excel 文件
  if (['csv', 'ods', 'xls', 'xlsb', 'xlsm', 'xlsx'].includes(extension)) {
    return FileType.EXCEL;
  }

  // Word 文件
  if (
    ['doc', 'docm', 'docx', 'dot', 'dotx', 'odt', 'rtf'].includes(extension)
  ) {
    return FileType.WORD;
  }

  // PDF 文件
  if (extension === 'pdf') {
    return FileType.PDF;
  }

  // PPT 文件
  if (
    ['odp', 'pot', 'potx', 'pps', 'ppsx', 'ppt', 'pptm', 'pptx'].includes(
      extension,
    )
  ) {
    return FileType.PPT;
  }

  return FileType.UNKNOWN;
}

/**
 * 判断文件是否属于指定类型
 * @param fileName 文件名或文件路径
 * @param fileType 期望的文件类型
 * @returns 是否匹配
 */
export function isFileType(fileName: string, fileType: FileType): boolean {
  return getFileType(fileName) === fileType;
}
