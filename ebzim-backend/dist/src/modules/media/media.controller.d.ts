import { MediaService } from './media.service';
export declare class MediaController {
    private readonly mediaService;
    constructor(mediaService: MediaService);
    uploadFile(file: any): Promise<import("./media.service").CloudinaryResponse>;
}
