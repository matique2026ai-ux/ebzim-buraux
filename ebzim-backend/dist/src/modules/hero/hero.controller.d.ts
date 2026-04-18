import { HeroService } from './hero.service';
import { CreateHeroSlideDto, UpdateHeroSlideDto } from './dto/create-hero-slide.dto';
export declare class HeroController {
    private readonly heroService;
    constructor(heroService: HeroService);
    findAll(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/hero-slide.schema").HeroSlideDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/hero-slide.schema").HeroSlide & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    getAdminTable(): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/hero-slide.schema").HeroSlideDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/hero-slide.schema").HeroSlide & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    })[]>;
    create(dto: CreateHeroSlideDto): Promise<import("mongoose").Document<unknown, {}, import("./schemas/hero-slide.schema").HeroSlideDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/hero-slide.schema").HeroSlide & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }>;
    update(id: string, dto: UpdateHeroSlideDto): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/hero-slide.schema").HeroSlideDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/hero-slide.schema").HeroSlide & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
    delete(id: string): Promise<(import("mongoose").Document<unknown, {}, import("./schemas/hero-slide.schema").HeroSlideDocument, {}, import("mongoose").DefaultSchemaOptions> & import("./schemas/hero-slide.schema").HeroSlide & import("mongoose").Document<import("mongoose").Types.ObjectId, any, any, Record<string, any>, {}> & Required<{
        _id: import("mongoose").Types.ObjectId;
    }> & {
        __v: number;
    } & {
        id: string;
    }) | null>;
}
